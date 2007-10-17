Return-Path: <linux-kernel-owner+w=401wt.eu-S935177AbXJQUp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935177AbXJQUp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760074AbXJQUpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:45:13 -0400
Received: from narury.org ([84.16.240.217]:34848 "EHLO narury.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822AbXJQUpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:45:11 -0400
Date: Wed, 17 Oct 2007 23:45:08 +0300
From: Riku Voipio <riku.voipio@iki.fi>
To: Adrian Bunk <bunk@kernel.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: hwmon/f75375s.c: buggy if()
Message-ID: <20071017204508.GA32110@kos.to>
References: <20071017195439.GD3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017195439.GD3778@stusta.de>
X-message-flag: Warning: message not sent with a DRM-Certified client
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> <--  snip  -->
> 
> ...
> static ssize_t set_pwm_mode(struct device *dev, struct device_attribute *attr,
>                 const char *buf, size_t count)
> {
> ...
>         if (val != 0 || val != 1 || data->kind == f75373)
>                 return -EINVAL;
> ...
> 
> <--  snip  -->

> I'm not sure what exactly was intended, but it was for sure not intended 
> to always return -EINVAL...

Aiee. val should be 1 or 0, and kind must not be f75373.

Signed-off-by: Riku Voipio <riku.voipio@iki.fi>
---
 drivers/hwmon/f75375s.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
index f1df57a..885bfe9 100644
--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -344,7 +344,7 @@ static ssize_t set_pwm_mode(struct device *dev, struct device_attribute *attr,
    int val = simple_strtoul(buf, NULL, 10);
    u8 conf = 0;

-   if (val != 0 || val != 1 || data->kind == f75373)
+   if (!(val == 0 || val == 1 ) || data->kind == f75373)
        return -EINVAL;

    mutex_lock(&data->update_lock);
--
1.5.3.1


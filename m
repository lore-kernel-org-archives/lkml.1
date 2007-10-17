Return-Path: <linux-kernel-owner+w=401wt.eu-S1762184AbXJQTyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762184AbXJQTyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbXJQTyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:54:13 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44405 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753295AbXJQTyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:54:12 -0400
Date: Wed, 17 Oct 2007 21:54:39 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Riku Voipio <riku.voipio@iki.fi>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: hwmon/f75375s.c: buggy if()
Message-ID: <20071017195439.GD3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/hwmon/f75375s.c contains the following code:

<--  snip  -->

...
static ssize_t set_pwm_mode(struct device *dev, struct device_attribute *attr,
                const char *buf, size_t count)
{
...
        if (val != 0 || val != 1 || data->kind == f75373)
                return -EINVAL;
...

<--  snip  -->

I'm not sure what exactly was intended, but it was for sure not intended 
to always return -EINVAL...

Spotted by the Coverity checker.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


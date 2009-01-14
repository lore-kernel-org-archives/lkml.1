Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbZANWf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbZANWf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbZANWfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:35:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50509 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753316AbZANWfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:35:45 -0500
References: <200901141316.27584.david-b@pacbell.net>
Message-Id: <D7FBA37A-AB5A-47FE-A7AC-681E1E7DC5E4@opensource.wolfsonmicro.com>
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
In-Reply-To: <200901141316.27584.david-b@pacbell.net>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (5G77)
Mime-Version: 1.0 (iPhone Mail 5G77)
Subject: Re: [patch 2.6.29-rc] regulator: minor cleanup of virtual consumer
Date: Wed, 14 Jan 2009 22:36:14 +0000
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Jan 2009, at 21:16, David Brownell <david-b@pacbell.net> wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
>
> Minor cleanup to the regulator set_mode sysfs support:
> switch to sysfs_streq() in set_mode(), which is also
> a code shrink.  Use the same strings that get_mode()
> uses, shrinking data too.
>
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Excellent, thanks!

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

>
> ---
> drivers/regulator/virtual.c |    8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)
>
> --- a/drivers/regulator/virtual.c
> +++ b/drivers/regulator/virtual.c
> @@ -226,13 +226,13 @@ static ssize_t set_mode(struct device *d
>    unsigned int mode;
>    int ret;
>
> -    if (strncmp(buf, "fast", strlen("fast")) == 0)
> +    if (sysfs_streq(buf, "fast\n") == 0)
>        mode = REGULATOR_MODE_FAST;
> -    else if (strncmp(buf, "normal", strlen("normal")) == 0)
> +    else if (sysfs_streq(buf, "normal\n") == 0)
>        mode = REGULATOR_MODE_NORMAL;
> -    else if (strncmp(buf, "idle", strlen("idle")) == 0)
> +    else if (sysfs_streq(buf, "idle\n") == 0)
>        mode = REGULATOR_MODE_IDLE;
> -    else if (strncmp(buf, "standby", strlen("standby")) == 0)
> +    else if (sysfs_streq(buf, "standby\n") == 0)
>        mode = REGULATOR_MODE_STANDBY;
>    else {
>        dev_err(dev, "Configuring invalid mode\n");

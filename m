Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbZFELqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbZFELqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 07:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZFELqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 07:46:38 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:53550 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZFELqi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:46:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=s5VKlaQZULMi+tDUNmiYXxTuQ++jlgEvO/aEczsmoZS6TOJIYepim3s8Nlhw/HeoKJ
         KqjgbZ1cBQMuW4LjOUSDZEviT6faFmx8zrkKEKrrf1PFLmuPpjt1vK3vkDjIj+dsWZxt
         bLGUslJH3dFP/9oMIOZpekMCcxBDwiKsJOWlw=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0906051157460.22218@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0906051157460.22218@melkki.cs.Helsinki.FI>
Date: Fri, 5 Jun 2009 13:46:38 +0200
Message-ID: <71cd59b00906050446g7310d24el94f0d137dc0e0ecf@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
From: Corentin Chary <corentin.chary@gmail.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 5, 2009 at 10:59 AM, Pekka J Enberg<penberg@cs.helsinki.fi> wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
>
> If we leave the camera disabled by default, userspace programs (e.g.
> Skype, Cheese) leave the user out in the cold saying that the machine "has
> no camera." Therefore, it's better to enable camera by default and let
> people who really don't want it just disable the thing.
>
> Cc: <acpi4asus-user@lists.sourceforge.net>
> Cc: Len Brown <len.brown@intel.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  drivers/platform/x86/eeepc-laptop.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index 353a898..c0f8eb1 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -334,6 +334,19 @@ static int eeepc_bluetooth_rfkill_state(void *data, enum rfkill_state *state)
>  }
>
>  /*
> + * Camera helpers
> + */
> +
> +static void eeepc_enable_camera(void)
> +{
> +       int err;
> +
> +       err = set_acpi(CM_ASL_CAMERA, 1);
> +       if (err)
> +               printk(EEEPC_WARNING "Unable to enable camera %d\n", err);
> +}
> +
> +/*
>  * Sys helpers
>  */
>  static int parse_arg(const char *buf, unsigned long count, int *val)
> @@ -996,6 +1009,9 @@ static int __init eeepc_laptop_init(void)
>        result = eeepc_hwmon_init(dev);
>        if (result)
>                goto fail_hwmon;
> +
> +       eeepc_enable_camera();
> +
>        /* Register platform stuff */
>        result = platform_driver_register(&platform_driver);
>        if (result)
> --
> 1.5.6.3
>
>

Hi,
First, I think a one line
set_acpi(CM_ASL_CAMERA, 1);
with a small comment is better. (If it fails, it's because there no
camera, so we don't mind).

Anyway, I'm not sure it's a good idea to enable the camera by default.
It depends how many
power the camera is using (when idle). Coud you check that (with power
top maybe ?).

Thanks
-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbZFBWEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbZFBWEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbZFBWEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:04:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:56391 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbZFBWEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:04:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=r/vW2Qk99LJz4o2vms+2R1zOMtoMm8TPavQxMwT+5PPHbB1Ak0B/r14Mdta+bWGEso
         nrI8vWbP4MZ+1bxWTXTnAxKgyMZqlHfDybHqzq3bQQh52tjA5Gzcqr4UVgJIXg4QAh6m
         2ccvQqgE8Ct4oG7PiOK0HEEAi5WLadmqqe4Io=
Message-ID: <4A25A1DC.3000305@gmail.com>
Date: Wed, 03 Jun 2009 00:04:12 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1pre) Gecko/20090525 SUSE/3.0b2-10.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       uclinux-dist-devel@blackfin.uclinux.org, Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH] tty: bfin_jtag_comm: emulate a TTY over the Blackfin
 EMUDAT/JTAG interface
References: <1243970734-31541-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1243970734-31541-1-git-send-email-vapier@gentoo.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2009 09:25 PM, Mike Frysinger wrote:
> diff --git a/drivers/char/bfin_jtag_comm.c b/drivers/char/bfin_jtag_comm.c
> new file mode 100644
> index 0000000..854f265
> --- /dev/null
> +++ b/drivers/char/bfin_jtag_comm.c
> @@ -0,0 +1,365 @@
> +#define pr_init(fmt, args...) ({ static const __initdata char __fmt[] = fmt; printk(__fmt, ## args); })

This should be __initconst.

> +#define debug(fmt, args...) pr_debug(DRV_NAME ": " fmt, ## args)

Just define pr_fmt, instead of yet another debug macro.

> +static void
> +bfin_jc_wait_until_sent(struct tty_struct *tty, int timeout)
> +{
> +	unsigned long expire = jiffies + timeout;
> +	while (!circ_empty(&bfin_jc_write_buf)) {
> +		if (signal_pending(current))
> +			break;
> +		if (time_after(jiffies, expire))
> +			break;

Maybe some sort of sleep here?

> +	}
> +}

The tty handling is weird. You should take a reference before accessing
the structure.

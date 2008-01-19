Return-Path: <linux-kernel-owner+w=401wt.eu-S1762892AbYASRAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892AbYASRAu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 12:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756448AbYASRAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 12:00:43 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:38315 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbYASRAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 12:00:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kwvaojn7TfQbEXXqjaZ0HaCeYu6ylrg5enlJfsF7swR3WAQAeZQVe6/mRWfcJcxVQ3dQhzzbl1QrOBDH2J0EPsa+C7bDi9R6wTxhqUd/ZcfPTBM332+xtKTQGBa9Z6cGj3pNnaUQ4+rbbUa0tm5R9q+RyYCeJ2ZnQZNrgFhD4hU=
Message-ID: <2c0942db0801190900i11f0ff16saca04cafee0d62c3@mail.gmail.com>
Date: Sat, 19 Jan 2008 09:00:40 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86 reboot: Remove inb_p usage
Cc: mingo@redhat.com, akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080119154453.1afddbfb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080119154453.1afddbfb@lxorguk.ukuu.org.uk>
X-Google-Sender-Auth: 73ebab37e9dd455c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 19, 2008 7:44 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> We are driving a motherboard port so use a 2uS explicit delay at this
> point.
>
> Signed-off-by: Alan Cox <alan@redhat.com>
>
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc8-mm1/arch/x86/kernel/reboot.c linux-2.6.24-rc8-mm1/arch/x86/kernel/reboot.c
> --- linux.vanilla-2.6.24-rc8-mm1/arch/x86/kernel/reboot.c       2008-01-19 14:47:55.000000000 +0000
> +++ linux-2.6.24-rc8-mm1/arch/x86/kernel/reboot.c       2008-01-19 14:53:58.000000000 +0000
> @@ -319,9 +319,11 @@
>  {
>         int i;
>
> -       for (i = 0; i < 0x10000; i++)
> -               if ((inb_p(0x64) & 0x02) == 0)
> +       for (i = 0; i < 0x10000; i++) {
> +               if ((inb(0x64) & 0x02) == 0)
>                         break;
> +               udelay(2);
> +       }
>  }
>
>  void machine_emergency_restart(void)

Stupid question from the peanut gallery: If you're going to go through
all this, maybe it would be better to define an inline
isa_bus_delay(void) { udelay(2); } and use that instead? I can only
imagine some poor sod coming along later and wondering why there's a
udelay(2) there. OTOH, there is an inb right above it, so <shrug>.

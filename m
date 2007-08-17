Return-Path: <linux-kernel-owner+w=401wt.eu-S1764623AbXHQR50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764623AbXHQR50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 13:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758161AbXHQR5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 13:57:18 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:26514 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896AbXHQR5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 13:57:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Q2UpCEZb/hjOCb0DSvffloiv2A+bV0Gft2OtaELZUHvxItMUZhnbRTi0mLp3BoWz7B1skpZ00Y1EJMBtIwTXA45UxZPOb/edkFhtoAAcrpGThc1tAw5RElwyl97GrzNdX6UXGguLidfsB8yqNetePCBFePARsq9r0E+QlEK+GYs=
Message-ID: <8bd0f97a0708171057w52e3cd6ekf66a61e8292d3222@mail.gmail.com>
Date: Fri, 17 Aug 2007 13:57:16 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: [draft] Blackfin Early Printk implmentation
Cc: linux-kernel@vger.kernel.org, "Gerd Hoffmann" <kraxel@redhat.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Bryan Wu" <bryan.wu@analog.com>,
       "Sonic Zhang" <sonic.adi@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200708171336.40159.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708152234.06734.rgetz@blackfin.uclinux.org>
	 <46C4009F.9090206@redhat.com>
	 <200708171336.40159.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/17/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> +       asm("\tRETI = %0;\n"
> +           "\tRETX = %0;\n"
> +           "\tRETN = %0;\n"
> +           : : "p"(early_trap));

general note, i dont think inserting whitespace by hand in asm() is a
good thing ... i see it as whitenoise personally ...

> +int __init disable_early_printk(void)
> +{
> +       if (!early_console_initialized)
> +               return 0;
> +
> +       printk(KERN_INFO "Unregister %s%d\n", early_console_initialized->name,
> +               early_console_initialized->index);
> +       unregister_console(early_console_initialized);
> +       early_console_initialized = NULL;
> +       return 0;
> +}
> +
> +late_initcall(disable_early_printk);

i think we agreed this would be OK/good to have in common code
-mike

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbXELN6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbXELN6P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 09:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbXELN6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 09:58:00 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:34151 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbXELN6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 09:58:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=j3UMbDwrajvz0E3uDytrP6fobClWG0CY/hq0kOeRvw2s/+6lJMSmfZWphBvhi/sDVHjJAfRuVwK9m8QktiejMiB4qHXFwdhIx4IvDR+Ns5hCqRuFsE+3YG3GjnOGIHDFWE5EawOZZ9EmKqgxs6qhGALHjp1yEME2DVzB2XA/Wa8=
Subject: Re: undefined "pm3fb_setup()"
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705120628250.11988@localhost.localdomain>
References: <Pine.LNX.4.64.0705120628250.11988@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 12 May 2007 21:57:48 +0800
Message-Id: <1178978268.4773.14.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-12 at 06:32 -0400, Robert P. J. Day wrote:
>   i'm guessing someone's already spotted this but, with "make
> allyesconfig" on x86:
> 
> ...
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `pm3fb_init':
> drivers/video/pm3fb.c:977: undefined reference to `pm3fb_setup'
> ...
> 
>   the reason seems to be this excerpt from drivers/video/pm3fb.c:
> 
> ================================================================
> int __init pm3fb_init(void)
> {
>         /*
>          *  For kernel boot options (in 'video=pm3fb:<options>' format)
>          */
> #ifndef MODULE                       <-----------------------
>         char *option = NULL;
> 
>         if (fb_get_options("pm3fb", &option))
>                 return -ENODEV;
>         pm3fb_setup(option);
> #endif
> 
>         return pci_register_driver(&pm3fb_driver);
> }
> 
> static void __exit pm3fb_exit(void)
> {
>         pci_unregister_driver(&pm3fb_driver);
> }
> 
> #ifdef MODULE  

I've spotted this before, but forgotten about it.  Yes, the above should
be #ifndef

Tony



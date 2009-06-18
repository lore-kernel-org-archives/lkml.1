Return-Path: <linux-kernel-owner+w=401wt.eu-S1757639AbZFRTOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbZFRTOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZFRTOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:14:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751068AbZFRTOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:14:32 -0400
Date: Thu, 18 Jun 2009 12:13:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Riepe <michael.riepe@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Rudolf Marek <r.marek@assembler.cz>,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH] Enable coretemp driver on Intel Atom
Message-Id: <20090618121326.42ab9c2f.akpm@linux-foundation.org>
In-Reply-To: <49E7C34A.60007@googlemail.com>
References: <49E7C34A.60007@googlemail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009 01:46:18 +0200
Michael Riepe <michael.riepe@googlemail.com> wrote:

> This small patch enables the coretemp driver on an Intel Atom. I'm not
> sure if the readings are correct, however - on my 330, the driver
> reports values between 27 and 41 __C (with core1 being about 8__C hotter
> than core0, given the same load). Maybe the maximum temperature of 100
> __C is wrong for Atom CPUs.
> 
> -- 
> Michael "Tired" Riepe <michael.riepe@googlemail.com>
> X-Tired: Each morning I get up I die a little
> 
> 
> [linux-2.6.29.1-coretemp-atom.diff  text/plain (916B)]
> Signed-off-by: Michael Riepe <michael.riepe@googlemail.com>
> 
> Index: drivers/hwmon/coretemp.c
> ===================================================================
> RCS file: /var/cvs/sys/kernel/linux-2.6/drivers/hwmon/coretemp.c,v
> retrieving revision 1.1.1.5
> diff -u -r1.1.1.5 coretemp.c
> --- drivers/hwmon/coretemp.c	11 Jan 2009 21:29:23 -0000	1.1.1.5
> +++ drivers/hwmon/coretemp.c	16 Apr 2009 23:02:40 -0000
> @@ -185,7 +185,7 @@
>  		}
>  	}
>  
> -	if (ismobile) {
> +	if (ismobile || c->x86_model == 0x1c) {
>  
>  		err = rdmsr_safe_on_cpu(id, 0xee, &eax, &edx);
>  		if (err) {
> @@ -417,7 +417,7 @@
>  		if ((c->cpuid_level < 0) || (c->x86 != 0x6) ||
>  		    !((c->x86_model == 0xe) || (c->x86_model == 0xf) ||
>  			(c->x86_model == 0x16) || (c->x86_model == 0x17) ||
> -			(c->x86_model == 0x1A))) {
> +			(c->x86_model == 0x1A) || (c->x86_model == 0x1c))) {
>  
>  			/* supported CPU not found, but report the unknown
>  			   family 6 CPU */
> 

I'm not 100% sure what to do about this patch.  I'm inclined to merge
it, even though you think it might be giving the wrong numbers,
because then someone might fix it.

otoh, if giving the wrong numbers leads to people's machines needlessly
shutting down or something like that, then that's not so good.

Opinions are sought?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbYBQTlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbYBQTlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbYBQTkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:40:06 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:60486 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbYBQTkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:40:04 -0500
Date: Sun, 17 Feb 2008 20:40:13 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Avi Kivity <avi@qumranet.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc2, Problem running 'make install' as root with different gcc
Message-ID: <20080217194013.GK14588@uranus.ravnborg.org>
References: <47B85485.2020000@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B85485.2020000@qumranet.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 05:36:37PM +0200, Avi Kivity wrote:
> Trying to install a built 2.5.25-rc2 on a machine with a different gcc 
> installed fails with
> 
>  LDS     arch/x86/vdso/vdso.lds
> cc1: fatal error: opening output file arch/x86/vdso/vdso.lds: Permission 
> denied
> compilation terminated.
> make[1]: *** [arch/x86/vdso/vdso.lds] Error 1
> make: *** [vdso_install] Error 2
> 
> I believe this is due to arch/x86/vdso/.vdso.lds.cmd containing
> 
> cmd_arch/x86/vdso/vdso.lds := gcc -E -Wp,-MD,arch/x86/vdso/.vdso.lds.d  
> -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.1.1/include 
> -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h   -P -C 
> -D__ASSEMBLY__ -o arch/x86/vdso/vdso.lds arch/x86/vdso/vdso.lds.S
> 
> '-isystem /usr/lib/gcc/x86_64-redhat-linux/4.1.1/include' changes with 
> the gcc version, triggering the recompilation attempt, which fails since 
> my home directory is nfs mounted.
> 
> This didn't trigger with previous versions, and I have no idea how to 
> fix it.

We had a related issue and I have suggested Rolan to just drop
the implicit installation of vdso when we do a "make install".
It would still trigger if you did a make vdso_install but this is
very rare so here it would not matter.

The patch we discuss just drop the cdso_install dependency
in arch/x86/Makefile (likewise for powerpc).

	Sam

Return-Path: <linux-kernel-owner+w=401wt.eu-S932814AbYBNHnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814AbYBNHnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 02:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760386AbYBNHnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 02:43:23 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:36182 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758859AbYBNHnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 02:43:21 -0500
Date: Thu, 14 Feb 2008 08:43:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: pageexec@freemail.hu
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: vmsplice exploits, stack protector and Makefiles
Message-ID: <20080214074327.GD17552@uranus.ravnborg.org>
References: <20080212090001.3fcc4ca0@laptopd505.fenrus.org> <47B30F05.29637.9A21F9B@pageexec.freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B30F05.29637.9A21F9B@pageexec.freemail.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- linux-2.6.24.2/arch/x86/kernel/Makefile_64	2008-01-24 23:58:37.000000000 
> +0100
> +++ linux-2.6.24.2-pax/arch/x86/kernel/Makefile_64	2008-02-13 
> 11:36:14.000000000 +0100
> @@ -42,4 +42,6 @@ obj-$(CONFIG_PCI)		+= early-quirks.o
>  obj-y				+= topology.o
>  obj-y				+= pcspeaker.o
>  
> -CFLAGS_vsyscall_64.o		:= $(PROFILING) -g0
> +CFLAGS_vsyscall_64.o		:= $(PROFILING) -g0 -fno-stack-protector
> +CFLAGS_hpet.o			:= -fno-stack-protector
> +CFLAGS_tsc_64.o			:= -fno-stack-protector

We should use:
nostackp := $(call cc-option, -fno-stack-protector)
+CFLAGS_vsyscall_64.o		:= $(PROFILING) -g0 $(nostackp)
+CFLAGS_hpet.o			:= $(nostackp)
+CFLAGS_tsc_64.o		:= $(nostackp)

(or somthing similar)

because we cannot rely on that all gcc versions has support
for -fno-stack-protector

	Sam

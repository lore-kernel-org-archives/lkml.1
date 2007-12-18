Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbXLRFf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbXLRFf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 00:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbXLRFfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 00:35:46 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:54700 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbXLRFfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 00:35:45 -0500
Date: Tue, 18 Dec 2007 06:37:29 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
       Richard Henderson <rth@twiddle.net>, Michael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Chris Zankel <chris@zankel.net>,
       Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c (version 4)
Message-ID: <20071218053729.GA13238@uranus.ravnborg.org>
References: <200712172345.lBHNjgGq021212@tazenda.hos.anvin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712172345.lBHNjgGq021212@tazenda.hos.anvin.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/kernel/Makefile b/kernel/Makefile
> index dfa9695..749825a 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -80,3 +80,11 @@ quiet_cmd_ikconfiggz = IKCFG   $@
>  targets += config_data.h
>  $(obj)/config_data.h: $(obj)/config_data.gz FORCE
>  	$(call if_changed,ikconfiggz)
> +
> +$(obj)/time.o: $(obj)/timeconst.h
> +
> +quiet_cmd_timeconst  = TIMEC   $@
> +      cmd_timeconst  = $(PERL) $< $(CONFIG_HZ) > $@
> +targets += timeconst.h
> +$(obj)/timeconst.h: $(src)/timeconst.pl $(wildcard include/config/hz.h) FORCE
> +	$(call if_changed,timeconst)

The prerequisite $(wildcard include/config/hz.h) is not needed.
You will run the perl script if:
- timeconst.h is missing
- if commandline changes (new CONFIG_HZ value)

Otherwise it looks OK to me.

	Sam

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbXCRQYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbXCRQYl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 12:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbXCRQYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 12:24:41 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:37217 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbXCRQYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 12:24:40 -0400
From: Roman Zippel <zippel@linux-m68k.org>
To: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: fake config option w/kbuild?
Date: Sun, 18 Mar 2007 17:24:30 +0100
User-Agent: KMail/1.9.5
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <C6F49569-655E-4B17-B9DA-9644C8B3668D@kernel.crashing.org>
In-Reply-To: <C6F49569-655E-4B17-B9DA-9644C8B3668D@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703181724.32182.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 15 March 2007 16:19, Kumar Gala wrote:

> Guys, I was wondering if there was a way to have a fake config
> option, one that acts just like a normal config option, but doesn't
> get a #define CONFIG_<FOOBAR> .. for it and thus can't be used in code.
>
> I explain my problem, and maybe there is a better solution.
>
> I have a config option call QE that exists on two flavor's of
> powerpc.  For PPC, we have one top level menu to select the processor
> (in this case 83xx or 85xx).  We than have a second top level menu to
> select the platform (which board).  The platform menu is where I want
> the 'QE' option to exist.  Each flavor (83xx, 85xx) has its own
> Kconfig that defines what's in the platform menu.  However, the QE
> config choice is common between them.
>
> So for now we are doing something like:
>
> arch/powerpc/Kconfig:
>
> config QE
> 	bool
> 	default n
>
> arch/powerpc/platform/83xx/Kconfig:
>
> config QE_83xx
> 	bool "QUICC Engine Support"
>          select QE
>          depends on PPC_MPC836x || PPC_MPC832x
>          default y
>          ---help---
>            The QUICC Engine (QE) is a new generation of communications
>            coprocessors on Freescale embedded CPUs (akin to CPM in
> older chips).
>
> arch/powerpc/platform/85xx/Kconfig:
>
> config QE_85xx
> 	bool "QUICC Engine Support"
>          select QE
>          depends on PPC_MPC8568
>          default y
>          ---help---
>            The QUICC Engine (QE) is a new generation of communications
>            coprocessors on Freescale embedded CPUs (akin to CPM in
> older chips).
>
> My initial question is that I don't want anyone using CONFIG_QE_83xx
> or CONFIG_QE_85xx in code, the second part is if there is a way to
> remove duplicating the QE_83xx/QE_85xx options down in platform/8{3,5}
> xx/Kconfig.

The duplication is maybe difficult to avoid without moving it, but a symbol 
can have multiple prompts so you can just replace QE_8[35]xx with QE 
(although a little more verbose name wouldn't hurt either).

bye, Roman

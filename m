Return-Path: <linux-kernel-owner+w=401wt.eu-S1945904AbXBBIkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945904AbXBBIkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 03:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945905AbXBBIkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 03:40:25 -0500
Received: from bill.weihenstephan.org ([82.135.35.21]:50685 "EHLO
	bill.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945904AbXBBIkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 03:40:24 -0500
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: linux-kernel@vger.kernel.org
Subject: Re: Please revert "fix typo in geode_configre()@cyrix.c"
Date: Fri, 2 Feb 2007 09:40:20 +0100
User-Agent: KMail/1.9.4
Cc: Adrian Bunk <bunk@stusta.de>, takada <takada@mbf.nifty.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jordan Crouse <jordan.crouse@amd.com>
References: <20070202062941.GB3754@stusta.de>
In-Reply-To: <20070202062941.GB3754@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702020940.21071.juergen127@kreuzholzen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 February 2007 07:29, Adrian Bunk wrote:
> Since there is AFAIK no actually observed problem fixed by this, it
> should be safe to simply revert the patch for 2.6.20.

The most important fix was:

Index: linux-2.6.19/arch/i386/kernel/cpu/cyrix.c
===================================================================
--- linux-2.6.19.orig/arch/i386/kernel/cpu/cyrix.c
+++ linux-2.6.19/arch/i386/kernel/cpu/cyrix.c
@@ -173,6 +173,7 @@ static void __cpuinit geode_configure(vo
 	ccr4 = getCx86(CX86_CCR4);
 	ccr4 |= 0x38;		/* FPU fast, DTE cache, Mem bypass */

+	setCx86(CX86_CCR4, ccr4);
 	setCx86(CX86_CCR3, ccr3);

 	set_cx86_memwb();

to write back the modified register content. But yes, it works also without 
this fix (but faster with it).

Juergen

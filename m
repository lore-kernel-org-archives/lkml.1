Return-Path: <linux-kernel-owner+w=401wt.eu-S1760099AbYA1KN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099AbYA1KN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 05:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYA1KNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 05:13:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57642 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbYA1KNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 05:13:48 -0500
Date: Mon, 28 Jan 2008 11:13:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix usage of .section .sched.text in assembler
	code
Message-ID: <20080128101333.GB24010@elte.hu>
References: <20080126225306.GA27215@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080126225306.GA27215@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> Without this patch the linker will generate a section named 
> .sched.text.1 which is unexpected. This is because the gcc generated 
> section has "ax" but the assembler usage of .sched.text lacks the "ax" 
> specifier.

thanks, applied.

> It would be better to have a definition we could use from assembler 
> code but I did not find a suitable header file for it.

hm, include/asm-x86/linkage.h?

btw., i guess this in include/linux/linkage.h:

#ifndef __ALIGN
#define __ALIGN         .align 4,0x90
#define __ALIGN_STR     ".align 4,0x90"
#endif

is an x86-ism (0x90 is the x86 NOP instruction) that should move into 
include/asm-x86/linkge.h and the default filler should be 0x00 instead?

	Ingo

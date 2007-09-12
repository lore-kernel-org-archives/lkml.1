Return-Path: <linux-kernel-owner+w=401wt.eu-S970537AbXILRRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970537AbXILRRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764873AbXILRRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:17:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56843 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764871AbXILRRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:17:31 -0400
Date: Wed, 12 Sep 2007 10:15:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Markus <lists4me@web.de>, Jeff Chua <jeff.chua.linux@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>, linux-alpha@vger.kernel.org,
       Stefan Becker <Stefan.Becker@nokia.com>, Andi Kleen <ak@suse.de>,
       Dave Jones <davej@redhat.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Jakub Jelinek <jakub@redhat.com>, Jeff Dike <jdike@linux.intel.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       "Adrian Bunk \"\"" <bunk@kernel.org>
Subject: Re: [1/4] 2.6.23-rc6: known regressions
In-Reply-To: <46E81AC6.3000306@googlemail.com>
Message-ID: <alpine.LFD.0.999.0709121010300.16478@woody.linux-foundation.org>
References: <46E81AC6.3000306@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 Sep 2007, Michal Piotrowski wrote:
> 
> Subject         : x86_64 vdso patch is broken somehow?
> References      : http://lkml.org/lkml/2007/8/29/136
> Last known good : ?
> Submitter       : Chuck Ebbert <cebbert@redhat.com>
> Caused-By       : Andi Kleen <ak@suse.de>
>                   commit 2aae950b21e4bc789d1fc6668faf67e8748300b7
> Handled-By      : ?
> Status          : unknown

This should be fixed now. Just pushed out with commit 
95b08679963c78ce0d675224a6efdb5169f2bf75 ("x86_64: Add missing mask 
operation to vdso").

> Subject         : 2.6.23-rc3-git1 crash/stuck on VIA CN700 system
> References      : http://lkml.org/lkml/2007/8/20/174
> Last known good : ?
> Submitter       : Stefan Becker <Stefan.Becker@nokia.com>
> Caused-By       : Andi Kleen <ak@suse.de>
>                   commit 19d36ccdc34f5ed444f8a6af0cbfdb6790eb1177
> Handled-By      : Andi Kleen <ak@suse.de>
>                   Dave Jones <davej@redhat.com>
> Workaround      : http://lkml.org/lkml/2007/9/5/221
> Status          : problem is being debugged

This *seems* to be a VIA bug. Regardless, it should be fixed by commit 
a534b679180025aa324ebd63c05516e478551cfd ("x86_64: Remove CLFLUSH in 
text_poke()").

> Subject         : console is messed up after resume from s2ram or switching to console from X
> References      : http://lkml.org/lkml/2007/8/4/6
> Last known good : ?
> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> Caused-By       : ?
> Handled-By      : H. Peter Anvin <hpa@zytor.com>
>                   Antonino A. Daplas <adaplas@gmail.com>
> Workaround      : "s2ram --force --acpi_sleep 1 --vbe_mode"
> Status          : problem is being debugged

This needs to be re-tested (was it the BIOS register overwriting, 
perhaps?).

> Subject         : konqueror suddenly vanishing, "konqueror: Fatal IO error: client killed"
> References      : http://lkml.org/lkml/2007/7/22/86
> Last known good : ?
> Submitter       : Markus <lists4me@web.de>
> Caused-By       : ?
> Handled-By      : Ingo Molnar <mingo@elte.hu>
> Status          : problem is being debugged

This should probably be dropped. I don't think we have any new reports on 
it, and nobody else ever saw it.

> Subject         : uml on x86_64 compile error
> References      : http://lkml.org/lkml/2007/9/3/86
> Last known good : ?
> Submitter       : Adrian Bunk <bunk@kernel.org>
> Caused-By       : Jeff Dike <jdike@linux.intel.com>
>                   commit d1254b12c93e1e586137a2ffef71fd33cf273f35
> Handled-By      : ?
> Status          : unknown

This should be fixed by commit 980abe215b861891c39aba0936817c46f372143b 
("UML: Fix ELF_CORE_COPY_REGS build botch").

			Linus

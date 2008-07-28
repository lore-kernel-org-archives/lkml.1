Return-Path: <linux-kernel-owner+w=401wt.eu-S1762989AbYG1VXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762989AbYG1VXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762232AbYG1VVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:21:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47281 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762168AbYG1VVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:21:09 -0400
Date: Mon, 28 Jul 2008 23:20:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 0/24] x86: arch/x86/kernel/ cleanups
Message-ID: <20080728212052.GB9986@elte.hu>
References: <gustavo@las.ic.unicamp.br> <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_00,URIBL_BLACK autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	2.0 URIBL_BLACK            Contains an URL listed in the URIBL blacklist
	[URIs: checkpatch.pl]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gustavo F. Padovan <gustavo@las.ic.unicamp.br> wrote:

> Ingo,
> 
> I removed many extra whitespaces and tabs from arch/x86/kernel/

hm, we tend to do a full cleanup of files we touch for style 
cleanup.

You can check some style errors via:

  scripts/checkpatch.pl --file arch/x86/kernel/alternative.c

but it also makes sense to look at the file and figure out places that 
look ugly.

> 	x86: kernel/alternative.c cleanup

total: 4 errors, 15 warnings, 4 checks, 540 lines checked

> 	x86: kernel/apm_32.c cleanup

total: 6 errors, 27 warnings, 5 checks, 2416 lines checked

[ etc. ]

If we did each style problem separately we'd be generating over 1 
million commits for the entire tree - that's not feasible. So we go per 
file and once a file has been cleaned up, we keep it clean.

Note, checkpatch errors can be false positives occasionally, and not all 
warnings have to be fixed all the time - ask if unsure about whether to 
fix something or not.

It's also useful to check that the .o's are unchanged after a cleanup. 
You can see commits that do that, for example:

 commit d4413732b54a17684e48fbb4b52fade5bf965b5d
 Author: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
 Date:   Tue Feb 19 23:51:27 2008 +0100

    x86: coding style fixes to arch/x86/oprofile/op_model_athlon.c

    The patch fixes 33 errors and a few warnings reported by checkpatch.pl

    arch/x86/oprofile/op_model_athlon.o:
       text    data     bss     dec     hex filename
       1691       0      32    1723     6bb op_model_athlon.o.before
       1691       0      32    1723     6bb op_model_athlon.o.after
    md5:
    c354bc2d7140e1e626c03390eddaa0a6  op_model_athlon.o.before.asm
    c354bc2d7140e1e626c03390eddaa0a6  op_model_athlon.o.after.asm

    Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

	Ingo

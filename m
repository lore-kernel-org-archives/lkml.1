Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbZAGNEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbZAGNEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbZAGNEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:04:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41638 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827AbZAGNEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:04:32 -0500
Date: Wed, 7 Jan 2009 14:04:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: apw@canonical.com, davej@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: scripts/checkpatch.pl : undefined value as an ARRAY reference
Message-ID: <20090107130415.GC3529@elte.hu>
References: <3f9a31f40901070454x678f75d2xee2a6de04a940321@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901070454x678f75d2xee2a6de04a940321@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:

> Hello Andy,
> 
> On -tip git I am getting this error:
> 
> $ ./scripts/checkpatch.pl 000*
> Can't use an undefined value as an ARRAY reference at
> ./scripts/checkpatch.pl line 451.
> 
> But earlier it was working great. Is this a feature or a bug.

bug.

One for the akpm bucket i think, Andrew pushed v26 checkpatch to Linus 
yesterday:

57b9c6d: checkpatch: version: 0.26
21caa13: checkpatch: fix the perlcritic errors
2b6db5c: checkpatch: struct file_operations should normally be const
b53c8e1: checkpatch: ensure we actually detect if assignments split across lines
2d1bafd: checkpatch: do not report nr_static as a static declaration
4635f4f: checkpatch: track #ifdef/#else/#endif when tracking blocks
8b1b337: checkpatch: fix continuation detection when handling spacing on operators
8054576: checkpatch: loosen spacing on typedef function checks
080ba92: checkpatch: try to catch missing VMLINUX_SYMBOL() in vmlinux.lds.h
86f9d05: checkpatch: allow parentheses on return for comparisons
1e85572: checkpatch: Add warning for p0-patches
2a5a2c2: checkpatch: update copyrights
50a7dcf: checkpatch: version: 0.25
6586386: checkpatch: dissallow spaces between stars in pointer types
fae17da: checkpatch: comment ends inside strings is most likely not an open comment
8e761b0: checkpatch: detect multiple bitfield declarations
5fe3af1: checkpatch: __weak is an official attribute
383099f: checkpatch: structure member assignments are not complex
83242e0: checkpatch: widen implied comment detection to allow multiple stars
721c1cb: checkpatch: comment detection may miss an implied comment on the last hunk
691d77b6: checkpatch: add checks for in_atomic()

one of those is causing this new warning.

	Ingo

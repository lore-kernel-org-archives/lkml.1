Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbYIIHTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbYIIHTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbYIIHTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:19:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43266 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177AbYIIHTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:19:42 -0400
Date: Tue, 9 Sep 2008 09:19:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Sanders <linux@sandersweb.net>, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080909071916.GD3412@elte.hu>
References: <200809081932.m88JWVZG013061@askone.hos.anvin.org> <200809081634.24257.linux@sandersweb.net> <48C59C6F.2000408@zytor.com> <200809081816.50484.linux@sandersweb.net> <20080909060548.GA8228@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909060548.GA8228@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * David Sanders <linux@sandersweb.net> wrote:
> 
> > On Monday 08 September 2008 17:43, H. Peter Anvin wrote:
> > > Does this patch fix that for you?
> > >
> > 
> > Yes, thanks.
> 
> it fixes build errors in my test setup too.

Sam, i've applied Peter's fix (see the commit below) - do you have any 
objections to us carrying this in x86/urgent? It's needed for the gcc 
fix/workaround.

	Ingo

--------------->
>From 095fbc7296ccfe41688e8ef136587b23f0e8c123 Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Mon, 8 Sep 2008 14:43:11 -0700
Subject: [PATCH] kbuild: fix cc-option and cc-option-yn

David Sanders wrote:

> I'm getting this error:
> as: unrecognized option `-mtune=generic32'
> I have binutils 2.17.

Use -c instead of -S in cc-option and cc-option-yn, so we can probe
options related to the assembler.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: kbuild devel <kbuild-devel@lists.sourceforge.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 scripts/Kbuild.include |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index d64e6ba..982dcae 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -105,12 +105,12 @@ as-instr = $(call try-run,\
 # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
 
 cc-option = $(call try-run,\
-	$(CC) $(KBUILD_CFLAGS) $(1) -S -xc /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",$(1),$(2))
 
 # cc-option-yn
 # Usage: flag := $(call cc-option-yn,-march=winchip-c6)
 cc-option-yn = $(call try-run,\
-	$(CC) $(KBUILD_CFLAGS) $(1) -S -xc /dev/null -o "$$TMP",y,n)
+	$(CC) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",y,n)
 
 # cc-option-align
 # Prefix align with either -falign or -malign

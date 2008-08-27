Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138AbYH0RCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbYH0RCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 13:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbYH0RCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 13:02:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50214 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYH0RCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 13:02:05 -0400
Date: Wed, 27 Aug 2008 13:02:01 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: remove warning of old objcopy and local functions
In-Reply-To: <20080826154721.9416e2e9.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.1.10.0808271300540.16904@gandalf.stny.rr.com>
References: <20080825130117.33fe34bc.sfr@canb.auug.org.au> <20080825060934.GB14993@elte.hu> <alpine.DEB.1.10.0808251434000.23923@gandalf.stny.rr.com> <20080825190103.GA24029@elte.hu> <20080826094627.5d627b5b.sfr@canb.auug.org.au> <20080826115113.806cfe23.sfr@canb.auug.org.au>
 <alpine.DEB.1.10.0808252324050.966@gandalf.stny.rr.com> <20080826154721.9416e2e9.sfr@canb.auug.org.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The warning messages about old objcopy and local functions spam the
user quite drastically.  Remove the warning until we can find a nicer
way of tell the user to upgrade their objcopy.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 scripts/recordmcount.pl |    6 ------
 1 file changed, 6 deletions(-)

Index: linux-tip.git/scripts/recordmcount.pl
===================================================================
--- linux-tip.git.orig/scripts/recordmcount.pl	2008-08-27 12:57:40.000000000 -0400
+++ linux-tip.git/scripts/recordmcount.pl	2008-08-27 12:58:03.000000000 -0400
@@ -262,12 +262,6 @@ sub update_funcs
 
 	# only use locals if objcopy supports globalize-symbols
 	if (!$use_locals) {
-	    print STDERR
-		"$inputfile: WARNING: referencing local function " .
-		"$ref_func for mcount\n" .
-		"\tConsider upgrading objcopy to support the globalize-" .
-		"symbols option.\n"
-		if (!$local_warn_once++);
 	    return;
 	}
 	$convert{$ref_func} = 1;

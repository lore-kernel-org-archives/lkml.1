Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517AbYHZBvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbYHZBvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 21:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbYHZBvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 21:51:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37308 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577AbYHZBvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 21:51:25 -0400
Date: Tue, 26 Aug 2008 11:51:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: objcopy version test for local symbols
Message-Id: <20080826115113.806cfe23.sfr@canb.auug.org.au>
In-Reply-To: <20080826094627.5d627b5b.sfr@canb.auug.org.au>
References: <20080825130117.33fe34bc.sfr@canb.auug.org.au>
	<20080825060934.GB14993@elte.hu>
	<alpine.DEB.1.10.0808251434000.23923@gandalf.stny.rr.com>
	<20080825190103.GA24029@elte.hu>
	<20080826094627.5d627b5b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Steve,

On Tue, 26 Aug 2008 09:46:27 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> On Mon, 25 Aug 2008 21:01:03 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> >
> > applied to tip/tracing/ftrace, also have integrated it into 
> > auto-ftrace-next. (without much testing - i hope it goes well)
> 
> Looks ok at a first glance, but it may spam my build logs a bit ...
> Anyway, we will see.

I was right, it produces way to many messages :-(

I applied the following patch for now.  It would be nice if this check
could be done once per build and warned about once as well.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

>From 54bc3035c76a242d14df554966110e5964b3eac3 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 26 Aug 2008 11:45:01 +1000
Subject: [PATCH] ftrace: silence overly verbose warning

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 scripts/recordmcount.pl |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index ee9e126..ef0c6db 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -262,12 +262,12 @@ sub update_funcs
 
 	# only use locals if objcopy supports globalize-symbols
 	if (!$use_locals) {
-	    print STDERR
-		"$inputfile: WARNING: referencing local function " .
-		"$ref_func for mcount\n" .
-		"\tConsider upgrading objcopy to support the globalize-" .
-		"symbols option.\n"
-		if (!$local_warn_once++);
+#	    print STDERR
+#		"$inputfile: WARNING: referencing local function " .
+#		"$ref_func for mcount\n" .
+#		"\tConsider upgrading objcopy to support the globalize-" .
+#		"symbols option.\n"
+#		if (!$local_warn_once++);
 	    return;
 	}
 	$convert{$ref_func} = 1;
-- 
1.5.6.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbYK1RI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbYK1RI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 12:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYK1RIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 12:08:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54471 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbYK1RIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 12:08:18 -0500
Date: Fri, 28 Nov 2008 18:08:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: T?r?k Edwin <edwintorok@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, srostedt@redhat.com,
       a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs, seqfile: make mangle_path() global
Message-ID: <20081128170805.GE10487@elte.hu>
References: <1227353328-16104-1-git-send-email-edwintorok@gmail.com> <1227353328-16104-3-git-send-email-edwintorok@gmail.com> <20081123084737.GE30453@elte.hu> <20081128100539.GN28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081128100539.GN28946@ZenIV.linux.org.uk>
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


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Sun, Nov 23, 2008 at 09:47:37AM +0100, Ingo Molnar wrote:
> > 
> > * T?r?k Edwin <edwintorok@gmail.com> wrote:
> > 
> > >  fs/seq_file.c            |   14 +++++++-
> > >  include/linux/seq_file.h |    1 +
> > 
> > Note, i've split these bits out into a separate patch - see it 
> > attached below.
> 
> ACK, [...]

thanks!

> [...] except that I wouldn't use _GPL in the export - it's trivial to 
> reproduce, so we are not protecting anything here.  And all that code 
> has been moved verbatim from seq_path(), which is mine *and* exported 
> without _GPL nonsense.
> 
> As far as I'm concerned, all these helpers are as general-purpose as 
> atoi() et.al. - library functions damn close to being non-copyrightable 
> due both to triviality and to being absolutely straightforward 
> implementations - tell anybody to implement it and that's what you'll 
> get.
> 
> I'm not fond of proprietary modules, to put it mildly, but let's not 
> get completely ridiculous.  In this case it's as dumb as schools trying 
> to ban aspirin in the name of War On Some Drugs.

okay, fair enough. Would the commit below be fine with you?

Also, since we depend on this commit, would it be fine with you if we 
carried the trivial patch in tip/tracing/*?

	Ingo

---------------->
>From 604094f4615180f71da799e7e5b191f5c2a42a28 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 28 Nov 2008 18:03:22 +0100
Subject: [PATCH] vfs, seqfile: export mangle_path() generally

mangle_path() is trivial enough to make  export restrictions on it
pointless - so change the export from EXPORT_SYMBOL_GPL to EXPORT_SYMBOL.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
---
 fs/seq_file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index f03220d..16c2115 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -387,7 +387,7 @@ char *mangle_path(char *s, char *p, char *esc)
 	}
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(mangle_path);
+EXPORT_SYMBOL(mangle_path);
 
 /*
  * return the absolute path of 'dentry' residing in mount 'mnt'.

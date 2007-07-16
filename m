Return-Path: <linux-kernel-owner+w=401wt.eu-S1759841AbXGPI0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841AbXGPI0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 04:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbXGPI0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 04:26:33 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56666 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463AbXGPI0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 04:26:31 -0400
Subject: Re: [EXT4 set 6][PATCH 1/1]Export jbd stats through procfs
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?ISO-8859-1?Q?=22C=E9dric?= "Augonnet\"" 
	<cedric.augonnet@gmail.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
In-Reply-To: <20070710214221.26539eb6.akpm@linux-foundation.org>
References: <1183275490.4010.134.camel@localhost.localdomain>
	 <20070710193117.a4ef6298.akpm@linux-foundation.org>
	 <f56c1ba00707102021k13a758cbx66cbb6ec8bffac49@mail.gmail.com>
	 <20070710214221.26539eb6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Organization: IBM Linux Technology Center
Date: Mon, 16 Jul 2007 01:26:31 -0700
Message-Id: <1184574391.4005.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-10 at 21:42 -0700, Andrew Morton wrote:
> On Tue, 10 Jul 2007 23:21:49 -0400 "Cédric Augonnet" <cedric.augonnet@gmail.com> wrote:
> 
> > 2007/7/10, Andrew Morton <akpm@linux-foundation.org>:
> > 
> > Hi all,
> > 
> > > > +     size = sizeof(struct transaction_stats_s);
> > > > +     s->stats = kmalloc(size, GFP_KERNEL);
> > > > +     if (s == NULL) {
> > > > +             kfree(s);
> > > > +             return -EIO;
> > >
> > > ENOMEM
> > 
> > I'm sorry if i missed some point, but i just don't see the use of such
> > a kfree here, not sure Andrew meant you should only return ENOMEM
> > instead, but why issuing those kfree(NULL), instead of just a if (!s)
> > return ENOMEM ?
> > 
> 
> You found a bug.  It was meant to be
> 
> 	if (s->stats == NULL)
> 
> 
The incremental fix patch is attached just FYI. It will be folded to the
parent patch once the parent patch is being updated.


---
 fs/jbd2/journal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22/fs/jbd2/journal.c
===================================================================
--- linux-2.6.22.orig/fs/jbd2/journal.c	2007-07-16 00:05:03.000000000 -0700
+++ linux-2.6.22/fs/jbd2/journal.c	2007-07-16 00:05:59.000000000 -0700
@@ -751,7 +751,7 @@ static int jbd2_seq_history_open(struct 
 		return -EIO;
 	size = sizeof(struct transaction_stats_s) * journal->j_history_max;
 	s->stats = kmalloc(size, GFP_KERNEL);
-	if (s == NULL) {
+	if (s->stats == NULL) {
 		kfree(s);
 		return -EIO;
 	}



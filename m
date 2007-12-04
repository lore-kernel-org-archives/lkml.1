Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbXLDVkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbXLDVkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbXLDVkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:40:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52563 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996AbXLDVkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:40:16 -0500
Date: Tue, 4 Dec 2007 22:39:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9483] circular locking dependency detected
Message-ID: <20071204213957.GA12772@elte.hu>
References: <20071130073446.GA7864@skywalker> <20071204212518.GA10020@elte.hu> <20071204133515.83b26277.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204133515.83b26277.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 4 Dec 2007 22:25:18 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > 
> > > =======================================================
> > > [ INFO: possible circular locking dependency detected ]
> > > 2.6.24-rc3 #6
> > > -------------------------------------------------------
> > > bash/2294 is trying to acquire lock:
> > > (&journal->j_list_lock){--..}, at: [<c01eee2f>] journal_try_to_free_buffers+0x76/0x10c
> > > 
> > > but task is already holding lock:
> > > (inode_lock){--..}, at: [<c01864b6>] drop_pagecache+0x48/0xd8
> > > 
> > > which lock already depends on the new lock.
> > 
> > Andrew, drop_pagecache() is root-only and it has some known deadlock, 
> > right?
> > 
> 
> yup.  It takes inode_lock at too high a level so it can walk the 
> per-sb inode lists.

Is there anyone genious enough to fix this? :-/

	Ingo

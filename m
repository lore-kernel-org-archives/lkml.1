Return-Path: <linux-kernel-owner+w=401wt.eu-S1752717AbZKTKwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbZKTKwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 05:52:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbZKTKwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 05:52:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36018 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbZKTKwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 05:52:03 -0500
Date: Fri, 20 Nov 2009 11:51:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
Message-ID: <20091120105154.GB12634@elte.hu>
References: <20091025225342.007138f5@infradead.org>
 <20091111020108.GA11423@localhost>
 <20091110223456.01ef355f@infradead.org>
 <4AFA6AEF.5060306@garzik.org>
 <20091111081905.270a4e55@infradead.org>
 <y0m3a4kpsiw.fsf@fche.csb>
 <4AFB4AC7.1090405@intel.com>
 <20091112072217.GA31719@elte.hu>
 <20091120104335.GB29143@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120104335.GB29143@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> Guys, I think both the inode number and name do have a use case.  For 
> file system developers observing the filesystem the inode number is 
> very useful, and if you look at the ext4 tracing already in tree or 
> the xfs tracing going in in the next window they use the inode number 
> all over.
> 
> Which btw brings up another good argument - to make the tracing really 
> useful we need to have conventions.  While the inode number seems to 
> be a realtively easy one printing the device is more difficult.  XFS 
> just prints the raw major/minor to stay simple, ext4 has a complicated 
> ad-hoc cache of device names, and this one just prints the superblock 
> id string.

Agreed.

> Of course for a user the name is a lot more meaninful, but also 
> relatively expensive to generate.  Then again I'm not even sure how 
> the last pathname component only here is all that useful - it can't be 
> used to easily find the file.

That's not the main point though - the point is for app developers (and 
users) being able to see 'oh, _that_ file it is, we need to fix that'. 
In the context of a specific app, the last component filename carries 
95% of the useful information.

Look at how PowerTOP does it, for a real-life usecase.

	Ingo

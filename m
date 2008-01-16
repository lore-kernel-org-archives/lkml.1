Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbYAPJHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbYAPJHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 04:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbYAPJHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 04:07:20 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:41282 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751482AbYAPJHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 04:07:18 -0500
Message-ID: <400474447.19383@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 16 Jan 2008 17:07:20 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Rubin <mrubin@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] Converting writeback linked lists to a tree based data structure
References: <20080115080921.70E3810653@localhost> <1200386774.15103.20.camel@twins> <532480950801150953g5a25f041ge1ad4eeb1b9bc04b@mail.gmail.com> <400452490.28636@ustc.edu.cn> <20080115194415.64ba95f2.akpm@linux-foundation.org> <400457571.32162@ustc.edu.cn> <20080115204236.6349ac48.akpm@linux-foundation.org> <400459376.04290@ustc.edu.cn> <20080115215149.a881efff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115215149.a881efff.akpm@linux-foundation.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JF4Ey-0000x4-5p@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 09:51:49PM -0800, Andrew Morton wrote:
> On Wed, 16 Jan 2008 12:55:07 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> 
> > On Tue, Jan 15, 2008 at 08:42:36PM -0800, Andrew Morton wrote:
> > > On Wed, 16 Jan 2008 12:25:53 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> > > 
> > > > list_heads are OK if we use them for one and only function.
> > > 
> > > Not really.  They're inappropriate when you wish to remember your
> > > position in the list while you dropped the lock (as we must do in
> > > writeback).
> > > 
> > > A data structure which permits us to interate across the search key rather
> > > than across the actual storage locations is more appropriate.
> > 
> > I totally agree with you. What I mean is to first do the split of
> > functions - into three: ordering, starvation prevention, and blockade
> > waiting.
> 
> Does "ordering" here refer to ordering bt time-of-first-dirty?

Ordering by dirtied_when or i_ino, either is OK.

> What is "blockade waiting"?

Some inodes/pages cannot be synced now for some reason and should be
retried after a while.

> > Then to do better ordering by adopting radix tree(or rbtree
> > if radix tree is not enough),
> 
> ordering of what?

Switch from time to location.

> > and lastly get rid of the list_heads to
> > avoid locking. Does it sound like a good path?
> 
> I'd have thaought that replacing list_heads with another data structure
> would be a simgle commit.

That would be easy. s_more_io and s_more_io_wait can all be converted
to radix trees.


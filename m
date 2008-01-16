Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbYAPFwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbYAPFwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 00:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbYAPFv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 00:51:56 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59789 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172AbYAPFvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 00:51:55 -0500
Date: Tue, 15 Jan 2008 21:51:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Michael Rubin <mrubin@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] Converting writeback linked lists to a tree based data
 structure
Message-Id: <20080115215149.a881efff.akpm@linux-foundation.org>
In-Reply-To: <400459376.04290@ustc.edu.cn>
References: <20080115080921.70E3810653@localhost>
	<1200386774.15103.20.camel@twins>
	<532480950801150953g5a25f041ge1ad4eeb1b9bc04b@mail.gmail.com>
	<400452490.28636@ustc.edu.cn>
	<20080115194415.64ba95f2.akpm@linux-foundation.org>
	<400457571.32162@ustc.edu.cn>
	<20080115204236.6349ac48.akpm@linux-foundation.org>
	<400459376.04290@ustc.edu.cn>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008 12:55:07 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> On Tue, Jan 15, 2008 at 08:42:36PM -0800, Andrew Morton wrote:
> > On Wed, 16 Jan 2008 12:25:53 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> > 
> > > list_heads are OK if we use them for one and only function.
> > 
> > Not really.  They're inappropriate when you wish to remember your
> > position in the list while you dropped the lock (as we must do in
> > writeback).
> > 
> > A data structure which permits us to interate across the search key rather
> > than across the actual storage locations is more appropriate.
> 
> I totally agree with you. What I mean is to first do the split of
> functions - into three: ordering, starvation prevention, and blockade
> waiting.

Does "ordering" here refer to ordering bt time-of-first-dirty?

What is "blockade waiting"?

> Then to do better ordering by adopting radix tree(or rbtree
> if radix tree is not enough),

ordering of what?

> and lastly get rid of the list_heads to
> avoid locking. Does it sound like a good path?

I'd have thaought that replacing list_heads with another data structure
would be a simgle commit.

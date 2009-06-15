Return-Path: <linux-kernel-owner+w=401wt.eu-S1764258AbZFOQBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764258AbZFOQBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764157AbZFOQAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:00:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764158AbZFOQAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:00:31 -0400
Date: Mon, 15 Jun 2009 08:58:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>,
       linuxram@us.ibm.com, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH 2/3] Do not unconditionally treat zones that fail
 zone_reclaim() as full
Message-Id: <20090615085840.63aa6cde.akpm@linux-foundation.org>
In-Reply-To: <20090615102829.GC23198@csn.ul.ie>
References: <1244717273-15176-1-git-send-email-mel@csn.ul.ie>
	<1244717273-15176-3-git-send-email-mel@csn.ul.ie>
	<alpine.DEB.1.10.0906110948080.29827@gentwo.org>
	<20090612103617.GC14498@csn.ul.ie>
	<20090612084456.b6e4edb6.akpm@linux-foundation.org>
	<20090615102829.GC23198@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 11:28:30 +0100 Mel Gorman <mel@csn.ul.ie> wrote:

> On Fri, Jun 12, 2009 at 08:44:56AM -0700, Andrew Morton wrote:
> > On Fri, 12 Jun 2009 11:36:17 +0100 Mel Gorman <mel@csn.ul.ie> wrote:
> > 
> > > On Thu, Jun 11, 2009 at 09:48:53AM -0400, Christoph Lameter wrote:
> > > > It needs to be mentioned that this fixes a bug introduced in 2.6.19.
> > > > Possibly a portion of this code needs to be backported to stable.
> > > > 
> > > 
> > > Andrew has sucked up the patch already so I can't patch it. Andrew, there
> > > is a further note below on the patch if you'd like to pick it up.
> > 
> > OK.
> > 
> > > On the stable front, I'm think that patches 1 and 2 should being considered
> > > -stable candidates. Patch 1 is certainly needed because it fixes up the
> > > malloc() stall and should be picked up by distro kernels as well. This patch
> > > closes another obvious hole albeit one harder to trigger.
> > > 
> > > Ideally patch 3 would also be in -stable so distro kernels will suck it up
> > > as it will help identify this problem in the field if it occurs again but
> > > I'm not sure what the -stable policy is on such things are.
> > 
> > Well, I tagged the patches for stable but they don't apply at all well
> > to even 2.6.30 base.
> > 
> 
> What's the proper way to handle such a situation? Wait until the patches
> go to mainline and post a rebased version to stable?

Yes please.  I assume that when Greg&Chris try to apply the patch,
we'll hear squawks to remind us of this.

Of course, it'd be better if the patch didn't get rejects.  Perhaps
whatever-patch-clashed should also be backported.


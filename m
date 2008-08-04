Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbYHDAcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbYHDAcW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 20:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbYHDAcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 20:32:13 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:57402 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030AbYHDAcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 20:32:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkwMAMfolUh5LBjh/2dsb2JhbACKZKJl
X-IronPort-AV: E=Sophos;i="4.31,302,1215354600"; 
   d="scan'208";a="163431399"
Date: Mon, 4 Aug 2008 10:32:06 +1000
From: Dave Chinner <david@fromorbit.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>, Michael Shuey <shuey@purdue.edu>,
       Shehjar Tikoo <shehjart@cse.unsw.edu.au>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org, rees@citi.umich.edu, aglo@citi.umich.edu
Subject: Re: high latency NFS
Message-ID: <20080804003206.GB6119@disturbed>
Mail-Followup-To: "J. Bruce Fields" <bfields@fieldses.org>,
	Neil Brown <neilb@suse.de>, Michael Shuey <shuey@purdue.edu>,
	Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
	rees@citi.umich.edu, aglo@citi.umich.edu
References: <200807241311.31457.shuey@purdue.edu> <20080730192110.GA17061@fieldses.org> <4890DFC7.3020309@cse.unsw.edu.au> <200807302235.50068.shuey@purdue.edu> <20080731031512.GA26203@fieldses.org> <18577.25513.494821.481623@notabene.brown> <20080801072320.GE6201@disturbed> <20080801191559.GI7764@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801191559.GI7764@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 03:15:59PM -0400, J. Bruce Fields wrote:
> On Fri, Aug 01, 2008 at 05:23:20PM +1000, Dave Chinner wrote:
> > On Thu, Jul 31, 2008 at 05:03:05PM +1000, Neil Brown wrote:
> > > You might want to track the max length of the request queue too and
> > > start more threads if the queue is long, to allow a quick ramp-up.
> > 
> > Right, but even request queue depth is not a good indicator. You
> > need to leep track of how many NFSDs are actually doing useful
> > work. That is, if you've got an NFSD on the CPU that is hitting
> > the cache and not blocking, you don't need more NFSDs to handle
> > that load because they can't do any more work than the NFSD
> > that is currently running is. 
> > 
> > i.e. take the solution that Greg banks used for the CPU scheduler
> > overload issue (limiting the number of nfsds woken but not yet on
> > the CPU),
> 
> I don't remember that, or wasn't watching when it happened.... Do you
> have a pointer?

Ah, I thought that had been sent to mainline because it was
mentioned in his LCA talk at the start of the year. Slides
65-67 here:

http://mirror.linux.org.au/pub/linux.conf.au/2007/video/talks/41.pdf

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

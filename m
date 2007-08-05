Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbXHERXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbXHERXN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 13:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbXHERXC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 13:23:02 -0400
Received: from main.gmane.org ([80.91.229.2]:47791 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbXHERXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 13:23:00 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Brice Figureau <brice+lklm@daysofwonder.com>
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Date: Sun, 5 Aug 2007 17:22:43 +0000 (UTC)
Message-ID: <loom.20070805T190600-28@post.gmane.org>
References: <20070803123712.987126000@chello.nl> <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org> <20070804063217.GA25069@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 213.41.177.193 (Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en; rv:1.8.1.4) Gecko/20070509 Camino/1.5)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ingo Molnar <mingo <at> elte.hu> writes:
> * Linus Torvalds <torvalds <at> linux-foundation.org> wrote:
> > On Fri, 3 Aug 2007, Peter Zijlstra wrote:
> > > 
> > > These patches aim to improve balance_dirty_pages() and directly address 
> > > three issues:
> > >   1) inter device starvation
> > >   2) stacked device deadlocks
> > >   3) inter process starvation
> > 
> > Ok, the patches certainly look pretty enough, and you fixed the only 
> > thing I complained about last time (naming), so as far as I'm 
> > concerned it's now just a matter of whether it *works* or not. I guess 
> > being in -mm will help somewhat, but it would be good to have people 
> > with several disks etc actively test this out.
> 
> There are positive reports in the never-ending "my system crawls like an 
> XT when copying large files" bugzilla entry:
> 
>  http://bugzilla.kernel.org/show_bug.cgi?id=7372
> 
>[ snipped part of the bug report ]
> 
> so the whole problem area seems to be a "perfect storm" created by a 
> combination of TCQ, IO scheduling and VM dirty handling weaknesses. Per 
> device dirty throttling is a good step forward and it makes a very 
> visible positive difference.


Foreword: I'm the OP of bug #7372. 

I just want to say/add that:
 1) I'm running the per-bdi patch since about 30 days on a master mysql server
under somewhat mild load without any adverse effect I could notice.

 2) I _still_ don't get the "performances" of 2.6.17, but since that's the
better combination I could get, I think there is IMHO progress in the right
direction (to be compared to no progress since 2.6.18, that's better :-)).

To be honest, a vanilla 2.6.17 not tuned at all (ie vfs_cache_pressure and other
knobs in /proc/sys/vm like swappiness and dirty_*) is still better than any
other upcoming kernel I tested. Thus I still think 2.6.18 added a big regression
(which unfortunately I couldn't find).
Read the full bug report for any background information if needed.

Unfortunately it isn't practical to git-bisect my issue as the server is a
production server that can't be rebooted/stopped whenever I want (and since I
found workarounds of the issue...).

Thanks for showing interest in this issue.

Please CC: me on any answers as I'm not subscribed to the list.

--
Brice Figureau


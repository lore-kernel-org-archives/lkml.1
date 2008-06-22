Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbYFVSVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbYFVSVV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 14:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYFVSVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 14:21:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:42066 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbYFVSVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 14:21:13 -0400
Date: Sun, 22 Jun 2008 11:21:00 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, dgc@sgi.com
Subject: Re: [2.6.26-rc7] shrink_icache from pagefault locking (nee: nfsd
 hangs for a few sec)...
Message-ID: <20080622112100.794b1ae1@infradead.org>
In-Reply-To: <20080622181011.GC625@csn.ul.ie>
References: <6278d2220806220256g674304ectb945c14e7e09fede@mail.gmail.com>
	<6278d2220806220258p28de00c1x615ad7b2f708e3f8@mail.gmail.com>
	<20080622181011.GC625@csn.ul.ie>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2008 19:10:11 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> On (22/06/08 10:58), Daniel J Blueman didst pronounce:
> > I'm seeing a similar issue [2] to what was recently reported [1] by
> > Alexander, but with another workload involving XFS and memory
> > pressure.
> > 
> 
> Is NFS involved or is this XFS only? It looks like XFS-only but no
> harm in being sure.
> 
> I'm beginning to wonder if this is a problem where a lot of dirty
> inodes are being written back in this path and we stall while that
> happens. I'm still not getting why we are triggering this now and did
> not before 2.6.26-rc1 or why it bisects to the zonelist
> modifications. Diffing the reclaim and allocation paths between
> 2.6.25 and 2.6.26-rc1 has not yielded any candidates for me yet that
> would explain this.
> 

this sort of thing can easily be exposed with the latencytop tool... 
it will at least tell you WHAT the system is blocking on.
(not so much the why, the tool isn't smart enough to automatically spit
out kernel patches yet)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

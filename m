Return-Path: <linux-kernel-owner+w=401wt.eu-S1759880AbXFUR5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880AbXFUR5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756422AbXFUR5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:57:33 -0400
Received: from main.gmane.org ([80.91.229.2]:36871 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755111AbXFUR5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:57:33 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: James Bruce <bruce@andrew.cmu.edu>
Subject: Re: TUX2 filesystem
Date: Thu, 21 Jun 2007 13:57:15 -0400
Message-ID: <467ABBFB.5080108@andrew.cmu.edu>
References: <200706210705.34702.philipp.marek@bmlv.gv.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: dhcp-7-156.dsl.telerama.com
User-Agent: Icedove 1.5.0.10 (X11/20070329)
In-Reply-To: <200706210705.34702.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ph. Marek wrote:
> in Oct 2000 there's been some discussion "Tux2 - evil patents sighted" 
> (http://www.ussg.iu.edu/hypermail/linux/kernel/0010.0/0343.html), and in Aug 
> 2002 (http://www.uwsg.iu.edu/hypermail/linux/kernel/0208.3/0332.html) Daniel 
> wrote
>> It's well down my list of priorities because of uncertainties due to
>> the U.S. patent system. 
>> Does anybody want to know if patent chill exists, and is it hurting
>> open source? The answer is yes. 

I'm surprised this didn't come up sooner, but the situation is a little 
different now.  First, Sun is pushing ZFS quite a lot, even though it 
appears to violate pretty much all of Network Appliance's patents (ZFS 
is really not that much more than WAFL + extents + checksums AFAICT). 
Considering ZFS will be in Solaris, BSD, and MacOS, perhaps Sun feels 
that it is calling NA's bluff on the validity of the WAFL patents.

Second, Oracle is now working on Btrfs (if ever a FS needed a better 
name... is that pronounced ButterFS?).  Like Daniel pointed out when 
doing Tux2, the "hierarchical copy on write" approach used in WAFL, ZFS, 
Tux2 and Btrfs is _not_ that new of an idea in the database world. 
Maybe Oracle feels they can push out Btrfs because they have some prior 
art, or just that they have enough of a patent arsenal to keep NA from 
challenging them.

So, it is clear why individual developers and Ext* people would steer 
away from the NA patents, but large companies may not have to.  The 
recent US supreme court ruling may have helped out in that regard.

> It seems to me that this kind of filesystem could solve a few problems that 
> are currently attacked:
> - Atomic snapshots. Make a new superblock, and mount this copy in another
>   directory. As long as it's not overwritten, it stays consistent.
> - Speed/Consistency for Flash media. There is a list of superblocks, and when
>   the new block has been written the pointer from the old gets set - until the
>   first block in the list gets re-written.

It's been pretty clear at least in the research world that this is *the* 
approach if you want atomic snapshots.  COW is the obvious and sane way 
to do that, and file systems are trees, so COW on a tree is how you do 
efficient atomic snapshots on a filesystem.  There are still some issues 
with unexpected disk space usage (it requires _additional_ disk space to 
_delete_ a file), and it tends to use more memory (you want to delay 
client writes as much as possible, so you can allocate later and copy 
the least amount necessary), but once users wrap their heads around the 
concepts, many feel the benefits outweigh the drawbacks.

If patents hadn't stood in the way, we'd have had this stuff years ago. 
  At least there is some progress now, and better late than never.

   - Jim Bruce


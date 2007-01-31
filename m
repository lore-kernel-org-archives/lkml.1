Return-Path: <linux-kernel-owner+w=401wt.eu-S933105AbXAaLxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105AbXAaLxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 06:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933108AbXAaLxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 06:53:01 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:34922 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933105AbXAaLw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 06:52:59 -0500
Date: Wed, 31 Jan 2007 22:49:35 +1100
From: David Chinner <dgc@sgi.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mark Lord <lkml@rtr.ca>,
       Bron Gondwana <brong@fastmail.fm>, Mike Houston <mikeserv@bmts.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steve French <smfltc@us.ibm.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Daniel Drake <dsd@gentoo.org>, samba-technical@lists.samba.org,
       Vladimir Saveliev <vs@namesys.com>, reiserfs-dev@namesys.com,
       David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com
Subject: Re: How many people are using 2.6.16?
Message-ID: <20070131114935.GP33919298@melbourne.sgi.com>
References: <45BE5948.6060403@redhat.com> <20070129160448.65fc63f3.mikeserv@bmts.com> <20070129221300.GC19422@brong.net> <20070130203933.GJ3754@stusta.de> <45BFF1F4.3060401@rtr.ca> <Pine.LNX.4.64.0701301748230.3611@woody.linux-foundation.org> <20070131070237.GT3754@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131070237.GT3754@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 08:02:37AM +0100, Adrian Bunk wrote:
> On Tue, Jan 30, 2007 at 06:36:48PM -0800, Linus Torvalds wrote:
> > The issue was somewhat confused by people certainly *reporting* it for 
> > older kernels. Also, as part of the dirty bit cleanups and sanity 
> > checkingwe did actually seem to fix a long-standing CIFS corruption (and 
> > apparently reisertfs/XFS problems too).
> > 
> > But the *common* case was actually introduced with 2.6.19, and 2.6.16 
> > wouldn't be affected. 
> 
> Thanks for the clarifications.
> 
> Regarding the longstanding CIFS/reiserfs/XFS problems, it seems the 
> status is:
....
> XFS:
> fix not yet in your tree

With the WARN_ON() in cancel_dirty_page() removed:

http://git2.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ecdfc9787fe527491baefc22dce8b2dbd5b2908d

XFS will behave exactly the same as 2.6.19 and previous releases.
The patches I sent were only ever really workarounds to greatly
reduce the race window that could lead to the warning being
triggered.

We really need Nick Piggin's invalidate/truncate/mmap race fixes to
properly solve the XFS issues uncovered by Linus' changes. Given
that we haven't had any reported cases of data corruption on XFS
(and I couldn't trigger any even when seeing the warnings) I think
we are fairly safe just maintaining the status quo and waiting the
right fix to make it's way into the tree....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

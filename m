Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbZDTG1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbZDTG1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 02:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbZDTG0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 02:26:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45297 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527AbZDTG0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 02:26:47 -0400
Date: Mon, 20 Apr 2009 07:26:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Michal Simek <michal.simek@petalogix.com>
Cc: Nate Straz <nate-ltp@refried.org>, subrata@linux.vnet.ibm.com,
       ltp-list@lists.sourceforge.net,
       John Williams <john.williams@petalogix.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [LTP] statvfs -> f_bavail
Message-ID: <20090420062642.GY26366@ZenIV.linux.org.uk>
References: <49E759FB.70103@petalogix.com> <49E847FB.1030801@petalogix.com> <20090417173107.GA3590@refried.org> <49EC1352.6010900@petalogix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EC1352.6010900@petalogix.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 08:16:50AM +0200, Michal Simek wrote:
> Nate Straz wrote:
> > On Apr 17 11:12, Michal Simek wrote:
> >   
> >>> don't you know what is the description of f_bavail in struct statvfs?
> >>> On my system I am getting zero for this entry that's why fsync02 failed.
> >>>   
> >>>       
> >> I track down where the problem comes from.
> >> There is problem for all fs which use simple_statfs function from
> >> fs/libfs.c.
> >> In open.c in vfs_statfs function is whole structure set to zero and then
> >> in simple_statfs not set this value.
> >> I think we should fix it in ltp code.
> >> Here is my proposed change. If is ok - I will generate proper patch.
> >>     
> >
> > If the problem is in the kernel, then it should be fixed in the kernel.
> > That's the whole point of LTP, pointing out problems in the kernel which
> > need to be fixed.  Patching LTP to work around f_bavail not being set
> > correctly is not the right thing to do.
> >   
> :-) And what about if is the kernel code ok? :-)
> Then IMHO is the right time to fix LTP.
> 
> The main question is if is or not.
> 
> Hi guys from linux-fsdevel: Can you told us what is the right solution
> for my problem above?

"Fields that are undefined for a particular file system are set to 0".
So what kind of fs are you running that on and is that sucker really
defined for it?  Note that if it's ramfs or tmpfs with -o nr_blocks=0,
there is no such thing as "amount of free space", reserved for root
or not.

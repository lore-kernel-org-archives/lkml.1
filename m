Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbYHATbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbYHATbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 15:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbYHATbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 15:31:47 -0400
Received: from verein.lst.de ([213.95.11.210]:33996 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbYHATbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 15:31:46 -0400
Date: Fri, 1 Aug 2008 21:31:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jasper Bryant-Greene <jasper@amiton.co.nz>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, util-linux-ng@vger.kernel.org
Subject: Re: XFS noikeep remount in 2.6.27-rc1-next-20080730
Message-ID: <20080801193133.GA838@lst.de>
References: <1217553598.3860.16.camel@luna.unix.geek.nz> <20080801073033.GF6201@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801073033.GF6201@disturbed>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0.882 () SUBJ_HAS_UNIQ_ID
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 05:30:33PM +1000, Dave Chinner wrote:
> On Fri, Aug 01, 2008 at 01:19:58PM +1200, Jasper Bryant-Greene wrote:
> > I mount a bunch of XFS filesystems with "noikeep,attr2,noatime", and a
> > couple also with "ro".
> > 
> > Sometimes I want to remount one of the "ro" ones "rw", to make changes.
> > This doesn't work anymore in 2.6.27-rc1-next-20080730. The last kernel I
> > tried which it worked in was 2.6.26 release.
> > 
> > luna ~ # mount -o remount,rw /usr
> > mount: /usr not mounted already, or bad option
> > 
> > luna ~ # dmesg | tail -n 1
> > [18702.291344] XFS: mount option "noikeep" not supported for remount
> > 
> > Is this intended behaviour?
> 
> Side effect of this commit:
> 
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-2.6.git;a=commit;h=0327f9d799ebb96f67c80dd732b1fdb09527365e
> 
> Christoph?

I'ts most likely a fallout, but I wonder why.  To get this behaviour
moutn would have to add all the options it finds in /proc/self/mounts
to the command line.

Added the util-linux-ng list to shed some light on this, but I suspect
I'll have to change xfs_fs_remount to check if the option passed in
is identical to the one we already have and only reject it when it
changes due to this mount(1) dumbness.

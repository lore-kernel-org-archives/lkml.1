Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbZHUCgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbZHUCgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 22:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZHUCgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 22:36:19 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:47490 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbZHUCgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 22:36:16 -0400
Subject: Re: mount.nfs: access denied by server
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Wu Fengguang <fengguang.wu@intel.com>,
       "Mr. Charles Edward Lever" <Chuck.Lever@oracle.com>
Cc: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090821012700.GA9937@localhost>
References: <20090820071315.GA14765@localhost>
	 <1250773349.5352.23.camel@heimdal.trondhjem.org>
	 <20090821012700.GA9937@localhost>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 22:36:11 -0400
Message-Id: <1250822171.6514.29.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 9 msgs/h 2 sum rcpts/h 11 sum msgs/h 2 total rcpts 1141 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 1CD73184EABF3A6A03F30E55EFFB76375E551622
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 157 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-21 at 09:27 +0800, Wu Fengguang wrote:
> On Thu, Aug 20, 2009 at 09:02:29PM +0800, Trond Myklebust wrote:
> > On Thu, 2009-08-20 at 15:13 +0800, Wu Fengguang wrote:
> > > Hi,
> > > 
> > > After upgrading NFS client kernel to latest linux-next, NFS mount
> > > failed:
> > > 
> > >         # mount -t nfs pxe:/cc /cc
> > >         mount.nfs: access denied by server while mounting pxe:/cc
> > > 
> > >         # uname -a
> > >         Linux hp 2.6.31-rc6-next-20090818 #61 SMP Thu Aug 20 14:46:10 CST 2009 x86_64 GNU/Linux 
> > > 
> > > However server log says OK:
> > > 
> > >         Aug 20 15:02:09 wu-t61 mountd[4599]: authenticated mount request from 192.168.11.6:973 for /cc (/cc)
> > >         Aug 20 15:02:09 wu-t61 mountd[4599]: authenticated unmount request from 192.168.11.6:974 for /cc (/cc)
> > > 
> > > However-2: nfsroot can be mounted at boot time. Server kernel has always been 2.6.30.
> > > 
> > > Any ideas?
> > > 
> > > Thanks,
> > > Fengguang
> > 
> > Can you try again after enabling mount debugging on the NFS client?
> > 
> > echo 512 > /proc/sys/sunrpc/nfs_debug
> 
> I used 1024 and found the mount failed here in nfs_walk_authlist():
> 
>         dfprintk(MOUNT, "NFS: server does not support requested auth flavor\ n");
>         nfs_umount(request);

Thanks Fengguang!

Chuck, this looks like one of yours. Could it be that you are hitting
the same Linux knfsd bug that Tom Haynes saw with a Solaris client?
AFAICR, the problem was that existing nfs servers do not set a default
auth flavour, and so you just have to try with auth_sys and see if it
succeeds...

Cheers
  Trond


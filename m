Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbXLITuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbXLITuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 14:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbXLITu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 14:50:28 -0500
Received: from mail.fieldses.org ([66.93.2.214]:59586 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbXLITu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 14:50:27 -0500
Date: Sun, 9 Dec 2007 14:50:03 -0500
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, gnome42@gmail.com,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Denis V. Lunev" <den@openvz.org>
Subject: Re: 2.6.24-rc3-git4 NFS crossmnt regression
Message-ID: <20071209195003.GB2138@fieldses.org>
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com> <20071207151444.af5d8e11.akpm@linux-foundation.org> <200712080043.29292.rjw@sisk.pl> <200712090220.44543.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712090220.44543.maximlevitsky@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2007 at 02:20:44AM +0200, Maxim Levitsky wrote:
> Due to the fact that I was bitten by this bug (I thought it is a feature), and a bit of lack
> of understanding of NFS4 I want to ask few questions about NFS:
> 
> 1) I want to export whole file-system  with submounts to a range of clients.
> As 'exports' manual says I can't do so, is that true?

Are you referring to the sentence in the description of "nohide" that
say "The  nohide  option  is  currently only effective on single host
exports.  It does not work reliably with  netgroup, subnet,  or wildcard
exports."?  I believe that's out of date.  This should work.

> Can you tell me how properly to use crossmnt and nohide?
> Where should I put those options in root file-system export or in submount export?

The easiest option is to add "crossmnt" to the root export.

> 2) NFS4 - I can't get it working:
> 
> *I have a LFS system, and this is what I did (NFS3 works fine, but crossmnt, and nohide seems not to work, probably due to above bug)
> 	I also have seen errors about stale handles 
> *Kernel - 2.6.24-rc3 with NFS3/4 client/server enabled on both host and guest. (both client and server running this kernel)
> *rpc.idmapd running on both client and server + all standard NFS3 tools
> *NFS tools 1.1.1 with nfs4 support compiled + without GSS (on server)
> * /etc/exports with fsid=0: (on server)
> 	/tmp *(fsid=0,insecure,rw,async,anonuid=100,anongid=1000)
> * mounting with -tnfs4 server:/ /mnt/tmp
> 
> Still doesn't work, using wireshark shows that
> 	NFSV4 COMPOUND call with
> 		Opcode: PUTROOTFH (24)
> 		Opcode: GETFH (10)
> 		Opcode: GETATTR (9)
> 
> Fails with 
> 	Reject State: AUTH_ERROR (1)
> 	Auth State: bad credential (seal broken) (1)
> 
> 
> Any ideas?

Your setup looks fine.  I assume this is the /proc/ bug again.

--b.

> 
> (I decided to switch to NFS4 only due to the lack of ability to see underlying mounts)
> 
> The system I am connecting to is a very old P1 system I use as a terminal
> (X and ssh)
> When I need to install something there I mount whole / of in on my main Core2 system
> chroot there, and compile/install.
> 
> 
> Best regrads,
> 	Maxim Levitsky

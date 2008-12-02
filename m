Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbYLBX3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbYLBX3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 18:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbYLBX2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 18:28:54 -0500
Received: from mail.samba.org ([66.70.73.150]:34265 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbYLBX2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 18:28:53 -0500
X-Greylist: delayed 1314 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2008 18:28:53 EST
Date: Tue, 2 Dec 2008 15:07:03 -0800
From: Jeremy Allison <jra@samba.org>
To: Andreas Dilger <adilger@sun.com>
Cc: Steve French <smfrench@gmail.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>
Subject: Re: Support for applications which need NFS or CIFS "share_deny"
	flags on open
Message-ID: <20081202230703.GB11904@jeremy-desktop>
Reply-To: Jeremy Allison <jra@samba.org>
References: <524f69650812020831q4e089b87k9a8306ac37f4234a@mail.gmail.com> <20081202193819.GJ3186@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202193819.GJ3186@webber.adilger.int>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 12:38:20PM -0700, Andreas Dilger wrote:
> On Dec 02, 2008  10:31 -0600, Steve French wrote:
> > Some of the Wine community posted last month to the cifs mailing list
> > asking about a change needed for Wine for working properly over
> > network mounts, but the change is not really cifs specific and would
> > help other file systems as well so I wanted to mention it here.   The
> > original post was:
> > http://marc.info/?l=linux-cifs-client&m=122505569315992&w=2
> > 
> > Support for the flags they suggest would be easy for cifs (the
> > protocol has a field for this, and cifs clients on various other OS
> > set it), and should be fairly easy for NFSv4 (the RFC for NFSv4
> > specifies the "share_deny" field within the NFS open request, and
> > various clients, but not Linux, set it), and would allow WINE to
> > function properly over a network mount.
> > 
> > >we proffer to add into the file /usr/include/asm-generic/fcntl.h
> > > following flags:
> > >
> > >#define O_DENYREAD      004000000 /* Do not permit read access */
> > >#define O_DENYWRITE     010000000 /* Do not permit write access */
> > >#define O_DENYDELETE  020000000 /* Do not permit delete or rename
> > > operations*/
> > 
> > Presumably for applications on local mounts, wine mediates their own
> > mandatory locks, but this is impossible on network mounts without this
> > change (and can lead to data corruption).
> 
> This is a disaster waiting to happen, and I would be against adding
> such functionality to Linux.  It would allow userspace applications
> to implement a denial of service to any file that they can open (e.g.
> open("/lib/libc-2.7.so", O_DENYREAD) would be really bad :-).

Indeed. If these flags are added it should only be for network
filesystem access, it would be a real mess for local access.

I guess it makes sense for them to be the inverse of the Windows
CreateFile call FILE_SHARE_READ|FILE_SHARE_WRITE|FILE_SHARE_DELETE
as by default Linux clients would use all these bits for a normal
open.

Jeremy.

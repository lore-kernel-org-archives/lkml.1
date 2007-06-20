Return-Path: <linux-kernel-owner+w=401wt.eu-S1757117AbXFTW5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117AbXFTW5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbXFTW5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:57:14 -0400
Received: from terminus.zytor.com ([192.83.249.54]:44836 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbXFTW5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:57:12 -0400
Message-ID: <4679B0C5.3030102@zytor.com>
Date: Wed, 20 Jun 2007 15:57:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: chuck.lever@oracle.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
 through other means
References: <467994BD.6000403@zytor.com> <20070620210343.GQ21478@ftp.linux.org.uk> <4679AB39.4010909@oracle.com> <4679AD0F.3040207@zytor.com> <4679AEA7.8050806@oracle.com>
In-Reply-To: <4679AEA7.8050806@oracle.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Lever wrote:
> The advantage is that it doesn't have strong user space dependencies on
> its format like /proc/mounts does.
> 
> If you have NFS mount points, you will see that it includes a great deal
> of additional information about each mount.

OK, I see now:
device raidtest:/export mounted on /net/raidtest/export with fstype nfs
statvers=1.0
        opts:
rw,vers=3,rsize=131072,wsize=131072,acregmin=3,acregmax=60,acdirmin=30,acdirmax=60,hard,proto=tcp,timeo=600,retrans=2,sec=sys
        age:    5
        caps:   caps=0x9,wtmult=4096,dtsize=4096,bsize=0,namelen=255
        sec:    flavor=1,pseudoflavor=1
        events: 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        bytes:  0 0 0 0 0 0 0 0
        RPC iostats version: 1.0  p/v: 100003/3 (nfs)
        xprt:   tcp 686 0 2 0 5 8 8 0 8 0
        per-op statistics
                NULL: 0 0 0 0 0 0 0 0
             GETATTR: 2 2 0 264 224 1 0 1
             SETATTR: 0 0 0 0 0 0 0 0
              LOOKUP: 0 0 0 0 0 0 0 0
              ACCESS: 1 1 0 116 120 0 0 0
            READLINK: 0 0 0 0 0 0 0 0
                READ: 0 0 0 0 0 0 0 0
               WRITE: 0 0 0 0 0 0 0 0
              CREATE: 0 0 0 0 0 0 0 0
               MKDIR: 0 0 0 0 0 0 0 0
             SYMLINK: 0 0 0 0 0 0 0 0
               MKNOD: 0 0 0 0 0 0 0 0
              REMOVE: 0 0 0 0 0 0 0 0
               RMDIR: 0 0 0 0 0 0 0 0
              RENAME: 0 0 0 0 0 0 0 0
                LINK: 0 0 0 0 0 0 0 0
             READDIR: 0 0 0 0 0 0 0 0
         READDIRPLUS: 0 0 0 0 0 0 0 0
              FSSTAT: 1 1 0 132 84 0 1 1
              FSINFO: 1 1 0 132 80 0 0 0
            PATHCONF: 0 0 0 0 0 0 0 0
              COMMIT: 0 0 0 0 0 0 0 0

This format is just awful for parsing.  It's pretty clearly totally
ad-hoc.  It's not even self-consistent (it uses different separators,
etc, in the same file!)  It's reasonably compact for human consumption,
but it doesn't show what the arrays mean.

Heck, XML would have been better than this mess...

	-hpa


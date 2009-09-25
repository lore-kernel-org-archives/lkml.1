Return-Path: <linux-kernel-owner+w=401wt.eu-S1752956AbZIYP1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbZIYP1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 11:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbZIYP1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 11:27:06 -0400
Received: from mx2.netapp.com ([216.240.18.37]:45681 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbZIYP1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 11:27:05 -0400
X-IronPort-AV: E=Sophos;i="4.44,452,1249282800"; 
   d="scan'208";a="249044549"
Subject: Re: NFS problem with past 2.6.31 git tree
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <c4e36d110909250812g74e049b7u39566d189970d77e@mail.gmail.com>
References: <c4e36d110909250812g74e049b7u39566d189970d77e@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Fri, 25 Sep 2009 11:27:05 -0400
Message-Id: <1253892426.31072.37.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
X-OriginalArrivalTime: 25 Sep 2009 15:27:08.0942 (UTC) FILETIME=[A5616AE0:01CA3DF4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-25 at 17:12 +0200, Zdenek Kabelac wrote:
> Hi
> 
> I've noticed that my qemu guest is now unable to use localy exported
> nfs directory.
> Directory gets mounted, plain 'ls' shows filenames - but nothing else
> could be done.
> 
> ls -la gives this output:
> ls: cannot access patch: Input/output error
> ...
> 
> 
> Both host & guest are running same kernel:
> 851b147e4411df6a1e7e90e2a609773c277eefd2
> 
> I've checked last few commits and tried to revert them -
> and this one seems to cure my problem when reverted:
> 
> Sep 23:  8a6e5deb8a8caa810fef2c525f5dbea2cfe04a47
> NFS: Get rid of the NFS_MOUNT_VER3 and NFS_MOUNT_TCP flags
> 
> I should also probably note that I'm seeing this message in my dmesg log:
> svc: failed to register lockdv1 RPC service (errno 97)
> 
> rpcinfo -p
>    program vers proto   port
>     100000    2   tcp    111  portmapper
>     100000    2   udp    111  portmapper
>     100024    1   udp  53550  status
>     100024    1   tcp  44174  status
>     100021    1   udp  49878  nlockmgr
>     100021    3   udp  49878  nlockmgr
>     100021    4   udp  49878  nlockmgr
>     100021    1   tcp  47319  nlockmgr
>     100021    3   tcp  47319  nlockmgr
>     100021    4   tcp  47319  nlockmgr
> 
> automount(pid1720) /misc autofs
> rw,relatime,fd=4,pgrp=1720,timeout=300,minproto=2,maxproto=4,indirect
> 0 0
> 192.168.122.1:/home/u/export /misc/u nfs
> rw,relatime,vers=3,rsize=524288,wsize=524288,namlen=255,soft,proto=tcp,port=65535,timeo=600,retrans=2,sec=sys,mountaddr=192.168.xxx.yyy,mountvers=3,mountproto=tcp,addr=192.168.xxx.yyy
> 0 0
> 
> 
> Zdenek
What does

   cat /proc/self/mountinfo

give you?

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

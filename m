Return-Path: <linux-kernel-owner+w=401wt.eu-S1752977AbZIYPMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbZIYPMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 11:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbZIYPMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 11:12:22 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:46384 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbZIYPMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 11:12:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=v93eZJn1k279rgrlqax8SQEmjMU53dqJgnYliMDQR1dusOrl6N3/H7Djta2Q/eYrli
         6rNs1cOFJh+oiIjrP1kglwY+i/6zxLRaVbSEaewoGPFzqzd3anPwe4zK4FMmejRdmkXG
         GXHBFOZ1mtpbGCbDl59HBn0X231/ZBVZSOSDQ=
MIME-Version: 1.0
Date: Fri, 25 Sep 2009 17:12:24 +0200
Message-ID: <c4e36d110909250812g74e049b7u39566d189970d77e@mail.gmail.com>
Subject: NFS problem with past 2.6.31 git tree
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Trond.Myklebust@netapp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've noticed that my qemu guest is now unable to use localy exported
nfs directory.
Directory gets mounted, plain 'ls' shows filenames - but nothing else
could be done.

ls -la gives this output:
ls: cannot access patch: Input/output error
...


Both host & guest are running same kernel:
851b147e4411df6a1e7e90e2a609773c277eefd2

I've checked last few commits and tried to revert them -
and this one seems to cure my problem when reverted:

Sep 23:  8a6e5deb8a8caa810fef2c525f5dbea2cfe04a47
NFS: Get rid of the NFS_MOUNT_VER3 and NFS_MOUNT_TCP flags

I should also probably note that I'm seeing this message in my dmesg log:
svc: failed to register lockdv1 RPC service (errno 97)

rpcinfo -p
   program vers proto   port
    100000    2   tcp    111  portmapper
    100000    2   udp    111  portmapper
    100024    1   udp  53550  status
    100024    1   tcp  44174  status
    100021    1   udp  49878  nlockmgr
    100021    3   udp  49878  nlockmgr
    100021    4   udp  49878  nlockmgr
    100021    1   tcp  47319  nlockmgr
    100021    3   tcp  47319  nlockmgr
    100021    4   tcp  47319  nlockmgr

automount(pid1720) /misc autofs
rw,relatime,fd=4,pgrp=1720,timeout=300,minproto=2,maxproto=4,indirect
0 0
192.168.122.1:/home/u/export /misc/u nfs
rw,relatime,vers=3,rsize=524288,wsize=524288,namlen=255,soft,proto=tcp,port=65535,timeo=600,retrans=2,sec=sys,mountaddr=192.168.xxx.yyy,mountvers=3,mountproto=tcp,addr=192.168.xxx.yyy
0 0


Zdenek

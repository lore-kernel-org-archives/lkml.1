Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbXIFH1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbXIFH1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 03:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbXIFH1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 03:27:32 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:2837 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbXIFH1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 03:27:31 -0400
Message-ID: <46DFAB7F.7060406@chelsio.com>
Date: Thu, 06 Sep 2007 00:25:51 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       takamiya@po.ntts.co.jp
Subject: net-26.24 broken with XFRM off
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Sep 2007 07:25:52.0749 (UTC) FILETIME=[280389D0:01C7F057]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

I get this error compiling net-2.6.24 with XFRM off:

[root@aries net-2.6.24]# make O=/opt/build/net-2.6.24
fatal: corrupted pack file 
.git/objects/pack/pack-39c494e9d4c6488e5911ee5c06926450679e6b78.pack
fatal: corrupted pack file 
.git/objects/pack/pack-39c494e9d4c6488e5911ee5c06926450679e6b78.pack
  Using /mnt/net-2.6.24 as source for kernel
  GEN     /opt/build/net-2.6.24/Makefile
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    /mnt/net-2.6.24/scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
net/built-in.o(.text+0x73ac2): In function `inet6_csk_xmit':
: undefined reference to `flow_cache_genid'
net/built-in.o(.text+0x73b9e): In function `inet6_csk_xmit':
: undefined reference to `flow_cache_genid'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [_all] Error 2

I believe this commit introduced it:
commit a85d5450ddeb959bdf9e4603f9c06e9d79217cfa
Author: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
Date:   Fri Aug 24 23:31:39 2007 -0700

    [IPV6] XFRM: Fix connected socket to use transformation.

Cheers,
Divy
   




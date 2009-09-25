Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592AbZIYXI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbZIYXI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 19:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbZIYXI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 19:08:58 -0400
Received: from mx2.netapp.com ([216.240.18.37]:56434 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbZIYXI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 19:08:58 -0400
X-IronPort-AV: E=Sophos;i="4.44,453,1249282800"; 
   d="scan'208";a="249217110"
Subject: Re: NFS problem with past 2.6.31 git tree
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <c4e36d110909251246s6af618e8n663afe2b66c4cd5d@mail.gmail.com>
References: <c4e36d110909250812g74e049b7u39566d189970d77e@mail.gmail.com>
	 <1253892426.31072.37.camel@heimdal.trondhjem.org>
	 <c4e36d110909251246s6af618e8n663afe2b66c4cd5d@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Fri, 25 Sep 2009 19:08:12 -0400
Message-Id: <1253920093.3549.25.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
X-OriginalArrivalTime: 25 Sep 2009 23:09:02.0063 (UTC) FILETIME=[2BB017F0:01CA3E35]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-25 at 21:46 +0200, Zdenek Kabelac wrote:
> Working version: (kernel 2.6.31 or current git with reverted NFS patch)
> 
> 22 12 0:17 / /misc rw,relatime - autofs automount(pid1720)
> rw,fd=4,pgrp=1720,timeout=300,minproto=2,maxproto=4,indirect
> 
> 24 22 0:19 / /misc/kabi rw,relatime - nfs IP:/home/kabi/export
> rw,vers=3,rsize=524288,wsize=524288,namlen=255,soft,proto=tcp,port=65535,timeo=600,retrans=2,sec=sys,mountaddr=IP,mountvers=3,mountproto=tcp,addr=IP
> 
> 
> Nonworking version:
> 
> 22 12 0:17 / /misc rw,relatime - autofs automount(pid1704)
> rw,fd=4,pgrp=1704,timeout=300,minproto=2,maxproto=4,indirect
> 
> 24 22 0:19 / /misc/kabi rw,relatime - nfs IP:/home/kabi/export
> rw,vers=2,rsize=8192,wsize=8192,namlen=255,soft,proto=tcp,port=65535,timeo=600,retrans=2,sec=sys,mountaddr=IP,mountvers=3,mountproto=tcp,addr=IP
> 
> 
> 
> Looks like vers=2  != vers=3   and rsize/wsize - which is also set by
> the kernel itself to those lower values.
> (i.e. my /etc/init.d/autofs doesn't modify localoptions - of course I
> could use this to set 8192 wsize and rsize for my working kernel)


Thanks for the report! I'll take a look at this over the weekend...

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

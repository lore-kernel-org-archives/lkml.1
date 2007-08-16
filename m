Return-Path: <linux-kernel-owner+w=401wt.eu-S934820AbXHPIpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934820AbXHPIpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 04:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934290AbXHPIev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 04:34:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934281AbXHPIeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 04:34:46 -0400
Subject: Re: [gfs2][RFC] readdir caused ls process into D (uninterruptible)
	state, under testing with Samba 3.0.25
From: Steven Whitehouse <swhiteho@redhat.com>
To: =?UTF-8?Q?=E7=A8=8B=E4=BB=BB=E5=85=A8?= <chengrq@uit.com.cn>
Cc: cluster-devel@redhat.com, Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <91b13c310708160120v7379d867k73ecf1995719d694@mail.gmail.com>
References: <91b13c310708160120v7379d867k73ecf1995719d694@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Thu, 16 Aug 2007 09:28:48 +0100
Message-Id: <1187252928.8765.881.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2007-08-16 at 16:20 +0800, 程任全 wrote:
> It seems that gfs2 cannot work well with Samba,
> 
> I'm using the gfs2 and the new cluster suite(cman with openais),
> 
> 1. the testing environment is that 1 iscsi target and 2 cluster node,
> 2. the two nodes both used iscsi initiator connect to the target,
> 3. they're using the same physical iscsi disk,
> 4. run LVM2 on top of the same iscsi disk,
> 5. on the same lv (logical volume), I created a gfs2 filesystem,
> 6. mount the gfs2 system to a same path under 2 nodes,
> 7. start samba to shared the gfs2 mounting pointer on the 2 nodes,
> 
> now test with windows client, when two or above clients connects to the samba,
> everything is still normal; but when heavy writers or readers start,
> the samba server daemon changed to D state, that's uninterruptible in
> the kernel,
> I wonder that's a problem of gfs2?
> 
Which version of gfs2 are you using? GFS2 doesn't support leases which I
know that Samba uses, however only relatively recent kernels have been
able to report that fact via the VFS.

> then I start a simple ls command on the gfs2 mouting point:
> $ ls /mnt/gfs2
> the ls process is also changed to D state,
> 
> I think it's problems about readdir implementation in gfs2, and I want
> to fix it, someone could give me some pointers?
> 
Can you get a stack trace? echo 't' >/proc/sysrq-trigger
That should show where Samba is getting stuck,

Steve.



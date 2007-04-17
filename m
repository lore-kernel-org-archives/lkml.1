Return-Path: <linux-kernel-owner+w=401wt.eu-S1161403AbXDQWoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161403AbXDQWoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 18:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161406AbXDQWoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 18:44:34 -0400
Received: from mx2.netapp.com ([216.240.18.37]:7599 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161403AbXDQWod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 18:44:33 -0400
X-IronPort-AV: i="4.14,420,1170662400"; 
   d="scan'208"; a="52078449:sNHT14927976"
Subject: Re: nfs: desynchronized value of nfs_i.ncommit.
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87hcrfaqam.fsf@duaron.myhome.or.jp>
References: <87hcrfaqam.fsf@duaron.myhome.or.jp>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Tue, 17 Apr 2007 18:44:30 -0400
Message-Id: <1176849870.6455.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 17 Apr 2007 22:44:37.0419 (UTC) FILETIME=[FA3827B0:01C78141]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-18 at 02:01 +0900, OGAWA Hirofumi wrote:
> Hi,
> 
> I've got the following message today. Probably, it happened on heavy load.
> 
> NFS: desynchronized value of nfs_i.ncommit.
> NFS: desynchronized value of nfs_i.ncommit.
> NFS: desynchronized value of nfs_i.ncommit.
> NFS: desynchronized value of nfs_i.ncommit.
> NFS: desynchronized value of nfs_i.ncommit.
> NFS: desynchronized value of nfs_i.ncommit.
> NFS: desynchronized value of nfs_i.ncommit.
> [...]
> 
> Any idea? Thanks.

It is a known issue that is due to nfs_writepage() 'stealing' requests
from the commit list. The most dangerous consequence is that it screws
up the NR_UNSTABLE_NFS page accounting...

I'm working on a fix, and will post it to lkml as soon as I'm happy with
tests.

Cheers
  Trond

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbZI2Ur0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbZI2Ur0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 16:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZI2UrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 16:47:25 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:38074 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbZI2UrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 16:47:24 -0400
Date: Tue, 29 Sep 2009 16:47:20 -0400
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, jack@suse.cz
Subject: Re: [PATCH] bdi_sync_writeback should WB_SYNC_NONE first
Message-ID: <20090929204720.GE6723@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, jens.axboe@oracle.com, jack@suse.cz
References: <20090925141014.GB15853@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090925141014.GB15853@think>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt016.oracle.com [141.146.116.25]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4AC2725A.010E:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 10:10:14AM -0400, Chris Mason wrote:
> At unmount time, we do writeback in two stages.  First we call
> sync_filesystems with wait == 0, and then we call it with wait == 1.
> 
> When wait == 1, WB_SYNC_ALL is used.  WB_SYNC_ALL will pass wait == 1 to
> the filesystem write_inode function if the inode was I_DIRTY_SYNC, and
> the filesystem write_inode function is then expected to commit the
> running transaction.
> 
> The new bdi threads try to keep this two stage writeback, but the
> problem is that they do it by calling bdi_writeback_all, which just
> kicks a few procs here and there and returns.
> 

And I can't reproduce any problems with mainline today.  ENOTABUG.

-chris


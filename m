Return-Path: <linux-kernel-owner+w=401wt.eu-S1758507AbXEPOFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbXEPOFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 10:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbXEPOEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 10:04:55 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:44391 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbXEPOEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 10:04:54 -0400
Date: Wed, 16 May 2007 08:04:52 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: Jeff Zheng <Jeff.Zheng@endace.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Software raid0 will crash the file-system, when each disk is 5TB
Message-ID: <20070516140452.GC5286@schatzie.adilger.int>
Mail-Followup-To: Jeff Zheng <Jeff.Zheng@endace.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 16, 2007  11:09 +1200, Jeff Zheng wrote:
> We are using two 3ware disk array controllers, each of them is connected
> 8 750GB harddrives. And we build a software raid0 on top of that. The
> total capacity is 5.5TB+5.5TB=11TB
> 
> We use jfs as the file-system, we have a test application that write
> data continuously to the disks. After writing 52 10GB files, jfs
> crashed. And we are not able to recover it, fsck doesn't recognise it
> anymore.
> We then tried xfs, same application, lasted a little longer, but gives
> kernel crash later.

Check if your kernel has CONFIG_LBD enabled.

The kernel doesn't check if the block layer can actually write to
a block device > 2TB.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.


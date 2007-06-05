Return-Path: <linux-kernel-owner+w=401wt.eu-S1763024AbXFEDwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763024AbXFEDwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 23:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760413AbXFEDwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 23:52:35 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:39626 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760205AbXFEDwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 23:52:34 -0400
Date: Mon, 4 Jun 2007 21:52:32 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vasily Averin <vvs@sw.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, linux-ext4@vger.kernel.org,
       Stephen Tweedie <sct@redhat.com>
Subject: Re: [RFC PATCH ext3/ext4] orphan list corruption due bad inode
Message-ID: <20070605035232.GC5181@schatzie.adilger.int>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Vasily Averin <vvs@sw.ru>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	devel@openvz.org, linux-ext4@vger.kernel.org,
	Stephen Tweedie <sct@redhat.com>
References: <4663A0CE.102@sw.ru> <20070604190340.dba85bb0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604190340.dba85bb0.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 04, 2007  19:03 -0700, Andrew Morton wrote:
> What caused those inodes to be bad, anyway?  Memory allocation failures?

This can happen if e.g. NFS has a stale file handle - it will look up
the inode by inum, but ext3_read_inode() will create a bad inode due to
i_nlink = 0.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.


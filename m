Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbXFYV4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbXFYV4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbXFYV43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:56:29 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:43560 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbXFYV41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:56:27 -0400
Date: Mon, 25 Jun 2007 15:56:25 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>,
       suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com
Subject: Re: [PATCH 7/7][TAKE5] ext4: support new modes
Message-ID: <20070625215625.GL5181@schatzie.adilger.int>
Mail-Followup-To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>,
	suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com
References: <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625135051.GH1951@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625135051.GH1951@amitarora.in.ibm.com>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 25, 2007  19:20 +0530, Amit K. Arora wrote:
> @@ -2499,7 +2500,8 @@ long ext4_fallocate(struct inode *inode,
>  	 * currently supporting (pre)allocate mode for extent-based
>  	 * files _only_
>  	 */
> -	if (mode != FA_ALLOCATE || !(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
> +	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) ||
> +		!(mode == FA_ALLOCATE || mode == FA_RESV_SPACE))
>  		return -EOPNOTSUPP;

This should probably just check for the individual flags it can support
(e.g. no FA_FL_DEALLOC, no FA_FL_DEL_DATA).

I also thought another proposed flag was to determine whether mtime (and
maybe ctime) is changed when doing prealloc/dealloc space?  Default should
probably be to change mtime/ctime, and have FA_FL_NO_MTIME.  Someone else
should decide if we want to allow changing the file w/o changing ctime, if
that is required even though the file is not visibly changing.  Maybe the
ctime update should be implicit if the size or mtime are changing?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.


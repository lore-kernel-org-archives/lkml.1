Return-Path: <linux-kernel-owner+w=401wt.eu-S967597AbXEHBHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967597AbXEHBHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 21:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966642AbXEHBHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 21:07:40 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:57879 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966205AbXEHBHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 21:07:39 -0400
Date: Mon, 7 May 2007 18:07:36 -0700
From: Andreas Dilger <adilger@clusterfs.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com,
       cmm@us.ibm.com
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
Message-ID: <20070508010736.GO8181@schatzie.adilger.int>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com,
	cmm@us.ibm.com
References: <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426181332.GD7209@amitarora.in.ibm.com> <20070503213133.d1559f52.akpm@linux-foundation.org> <20070507113753.GA5439@schatzie.adilger.int> <20070507135825.f8545a65.akpm@linux-foundation.org> <20070507222103.GJ8181@schatzie.adilger.int> <463FB008.3080706@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463FB008.3080706@garzik.org>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 07, 2007  19:02 -0400, Jeff Garzik wrote:
> Andreas Dilger wrote:
> >Actually, this is a non-issue.  The reason that it is handled for 
> >extent-only is that this is the only way to allocate space in the
> >filesystem without doing the explicit zeroing.
> 
> Precisely /how/ do you avoid the zeroing issue, for extents?
> 
> If I posix_fallocate() 20GB on ext4, it damn well better be zeroed, 
> otherwise the implementation is broken.

In ext4 (as in XFS) there is a flag stored in the extent that tells if
the extent is initialized or not.  Reads from uninitialized extents will
return zero-filled data, and writes that don't span the whole extent
will cause the uninitialized extent to be split into a regular extent
and one or two uninitialized extents (depending where the write is).

My comment was just that the extent doesn't have to be explicitly zero
filled on the disk, by virtue of the fact that the uninitialized flag
will cause reads to return zero.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.


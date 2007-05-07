Return-Path: <linux-kernel-owner+w=401wt.eu-S967115AbXEGWVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967115AbXEGWVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966973AbXEGWVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:21:11 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:35182 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966671AbXEGWVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:21:09 -0400
Date: Mon, 7 May 2007 15:21:04 -0700
From: Andreas Dilger <adilger@clusterfs.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
Message-ID: <20070507222103.GJ8181@schatzie.adilger.int>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com,
	cmm@us.ibm.com
References: <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426181332.GD7209@amitarora.in.ibm.com> <20070503213133.d1559f52.akpm@linux-foundation.org> <20070507113753.GA5439@schatzie.adilger.int> <20070507135825.f8545a65.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507135825.f8545a65.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 07, 2007  13:58 -0700, Andrew Morton wrote:
> Final point: it's fairly disappointing that the present implementation is
> ext4-only, and extent-only.  I do think we should be aiming at an ext4
> bitmap-based implementation and an ext3 implementation.

Actually, this is a non-issue.  The reason that it is handled for extent-only
is that this is the only way to allocate space in the filesystem without
doing the explicit zeroing.  For other filesystems (including ext3 and
ext4 with block-mapped files) the filesystem should return an error (e.g.
-EOPNOTSUPP) and glibc will do manual zero-filling of the file in userspace.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.


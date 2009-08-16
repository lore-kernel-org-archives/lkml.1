Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbZHPCZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbZHPCZB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 22:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZHPCZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 22:25:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39536 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbZHPCY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 22:24:59 -0400
Date: Sat, 15 Aug 2009 22:25:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mark Lord <liml@rtr.ca>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
       linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH, RFC] xfs: batched discard support
Message-ID: <20090816022500.GA12392@infradead.org>
References: <20090816004705.GA7347@infradead.org> <4A876255.10606@rtr.ca> <4A876CA9.20906@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A876CA9.20906@rtr.ca>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 15, 2009 at 10:19:21PM -0400, Mark Lord wrote:
> Mark Lord wrote:
>> Christoph Hellwig wrote:
> ..
>>> Mark, any chance to try it?  Just create an XFS filesystem, age it a
>>> bit and then call the attached little trim.c program on the mountmoint
>>> (or any file inside the filesystem for that matter)
>> ..
>>
>> Looking at it now.  Thanks, Christoph!
> ..
>
> Fails to work on 64-bit kernel w/ 32-bit userspace (no compat ioctl).
> Rebuilding with 32-bit kernel now..

The actual ioctl is compatible, just add the

	case XFS_IOC_TRIM:
		return xfs_ioc_trim(mp, arg);

to xfs_file_compat_ioctl().  I'll add this to the next spin of the
patch.


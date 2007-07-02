Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbXGBJkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbXGBJkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 05:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbXGBJkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 05:40:37 -0400
Received: from styx.suse.cz ([82.119.242.94]:35362 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751008AbXGBJkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 05:40:36 -0400
Message-ID: <4688C812.9020200@suse.cz>
Date: Mon, 02 Jul 2007 11:40:34 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1) Gecko/20061107 SUSE/1.0.99-26 SeaMonkey/1.1b
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] Fix XFS_IOC_FSBULKSTAT{,_SINGLE} and XFS_IOC_FSINUMBERS
 in compat mode
References: <20070619132549.266927601@suse.cz> <20070619132726.893544847@suse.cz> <20070628034957.GE989688@sgi.com>
In-Reply-To: <20070628034957.GE989688@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> On Tue, Jun 19, 2007 at 03:25:52PM +0200, mmarek@suse.cz wrote:
>> +static int xfs_bulkstat_one_compat(
>> +	xfs_mount_t	*mp,		/* mount point for filesystem */
>> +	xfs_ino_t	ino,		/* inode number to get data for */
>> +	void		__user *buffer,	/* buffer to place output in */
>> +	int		ubsize,		/* size of buffer */
>> +	void		*private_data,	/* my private data */
>> +	xfs_daddr_t	bno,		/* starting bno of inode cluster */
>> +	int		*ubused,	/* bytes used by me */
>> +	void		*dibuff,	/* on-disk inode buffer */
>> +	int		*stat)		/* BULKSTAT_RV_... */
> 
> Hmmm - this is almost all duplicated code. It's pretty much what I
> described, but maybe not /quite/ what I had in mind here. It's a
> *big* improvement on the first version, but it seems now that the
> only real difference xfs_bulkstat_one() and
> xfs_bulkstat_one_compat() is copy_to_user() vs the discrete put_user
> calls.
> 
> I think we can remove xfs_bulkstat_one_compat() completely by using
> the same method you used with the xfs_inumber_fmt functions.

You mean xfs_ioc_bulkstat_compat() -> native xfs_bulkstat() -> native
xfs_bulkstat_one() -> a compat output formatter, so a
pointer-to-function passed to pointer-to-function? ;) I could (ab)use
the void *private_data arg which xfs_bulkstat passes unmodified to the
formatter; xfs_bulkstat_one() doesn't make use of it atm. I'll try it
and post the result in a while.

Michal

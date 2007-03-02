Return-Path: <linux-kernel-owner+w=401wt.eu-S1422655AbXCBA2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422655AbXCBA2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 19:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422656AbXCBA2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 19:28:33 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:13762 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422655AbXCBA2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 19:28:32 -0500
Date: Thu, 1 Mar 2007 16:28:18 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: Adam Litke <agl@us.ibm.com>
Cc: torvalds@linux-foundation.org, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Fix get_unmapped_area and fsync for hugetlb shm segments
Message-ID: <20070302002818.GF10643@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Adam Litke <agl@us.ibm.com>, torvalds@linux-foundation.org,
	ebiederm@xmission.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070301234608.29532.66932.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301234608.29532.66932.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 03:46:08PM -0800, Adam Litke wrote:
>  static inline int is_file_hugepages(struct file *file)
>  {
> -	return file->f_op == &hugetlbfs_file_operations;
> +	if (file->f_op == &hugetlbfs_file_operations)
> +		return 1;
> +	if (is_file_shm_hugepages(file))
> +		return 1;
> +
> +	return 0;
>  }
...
> +int is_file_shm_hugepages(struct file *file)
> +{
> +	int ret = 0;
> +
> +	if (file->f_op == &shm_file_operations) {
> +		struct shm_file_data *sfd;
> +		sfd = shm_file_data(file);
> +		ret = is_file_hugepages(sfd->file);
> +	}
> +	return ret;

A comment to prepare others for the impending doubletake might be nice.
Or maybe just open-coding the equality check for &huetlbfs_file_operations
in is_file_shm_hugepages() if others find it as jarring as I. Please
extend my ack to any follow-up fiddling with that.

The patch addresses relatively straightforward issues and naturally at
that.

Acked-by: William Irwin <bill.irwin@oracle.com>


-- wli

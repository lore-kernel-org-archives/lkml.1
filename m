Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbZIHXFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbZIHXFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZIHXFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 19:05:14 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:35128 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbZIHXFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 19:05:13 -0400
Date: Tue, 8 Sep 2009 16:05:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/20] ceph: ioctls
Message-Id: <20090908160509.bcf511dc.randy.dunlap@oracle.com>
In-Reply-To: <1252450601-17610-19-git-send-email-sage@newdream.net>
References: <1252450601-17610-1-git-send-email-sage@newdream.net>
	<1252450601-17610-4-git-send-email-sage@newdream.net>
	<1252450601-17610-5-git-send-email-sage@newdream.net>
	<1252450601-17610-6-git-send-email-sage@newdream.net>
	<1252450601-17610-7-git-send-email-sage@newdream.net>
	<1252450601-17610-8-git-send-email-sage@newdream.net>
	<1252450601-17610-9-git-send-email-sage@newdream.net>
	<1252450601-17610-10-git-send-email-sage@newdream.net>
	<1252450601-17610-11-git-send-email-sage@newdream.net>
	<1252450601-17610-12-git-send-email-sage@newdream.net>
	<1252450601-17610-13-git-send-email-sage@newdream.net>
	<1252450601-17610-14-git-send-email-sage@newdream.net>
	<1252450601-17610-15-git-send-email-sage@newdream.net>
	<1252450601-17610-16-git-send-email-sage@newdream.net>
	<1252450601-17610-17-git-send-email-sage@newdream.net>
	<1252450601-17610-18-git-send-email-sage@newdream.net>
	<1252450601-17610-19-git-send-email-sage@newdream.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt014.oracle.com [141.146.116.23]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4AA6E327.011D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Sep 2009 15:56:39 -0700 Sage Weil wrote:

> A few Ceph ioctls for getting and setting file layout (striping)
> parameters.
> 
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  fs/ceph/ioctl.c |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ceph/ioctl.h |   20 +++++++++++
>  2 files changed, 118 insertions(+), 0 deletions(-)
>  create mode 100644 fs/ceph/ioctl.c
>  create mode 100644 fs/ceph/ioctl.h


> diff --git a/fs/ceph/ioctl.h b/fs/ceph/ioctl.h
> new file mode 100644
> index 0000000..56f5e2c
> --- /dev/null
> +++ b/fs/ceph/ioctl.h
> @@ -0,0 +1,20 @@
> +#ifndef FS_CEPH_IOCTL_H
> +#define FS_CEPH_IOCTL_H
> +
> +#include <linux/ioctl.h>
> +#include <linux/types.h>
> +
> +#define CEPH_IOCTL_MAGIC 0x97
> +
> +/* just use u64 to align sanely on all archs */
> +struct ceph_ioctl_layout {
> +	__u64 stripe_unit, stripe_count, object_size;
> +	__u64 data_pool;
> +};
> +
> +#define CEPH_IOC_GET_LAYOUT _IOR(CEPH_IOCTL_MAGIC, 1,		\
> +				   struct ceph_ioctl_layout)
> +#define CEPH_IOC_SET_LAYOUT _IOW(CEPH_IOCTL_MAGIC, 2,		\
> +				   struct ceph_ioctl_layout)
> +
> +#endif
> -- 

Please also update Documentation/ioctl/ioctl-number.txt


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/

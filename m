Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbZGVWj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbZGVWj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 18:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbZGVWj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 18:39:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41700 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbZGVWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 18:39:26 -0400
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/19] ceph: ioctls
From: Andi Kleen <andi@firstfloor.org>
References: <1248292313-31326-1-git-send-email-sage@newdream.net>
	<1248292313-31326-2-git-send-email-sage@newdream.net>
	<1248292313-31326-3-git-send-email-sage@newdream.net>
	<1248292313-31326-4-git-send-email-sage@newdream.net>
	<1248292313-31326-5-git-send-email-sage@newdream.net>
	<1248292313-31326-6-git-send-email-sage@newdream.net>
	<1248292313-31326-7-git-send-email-sage@newdream.net>
	<1248292313-31326-8-git-send-email-sage@newdream.net>
	<1248292313-31326-9-git-send-email-sage@newdream.net>
	<1248292313-31326-10-git-send-email-sage@newdream.net>
	<1248292313-31326-11-git-send-email-sage@newdream.net>
	<1248292313-31326-12-git-send-email-sage@newdream.net>
	<1248292313-31326-13-git-send-email-sage@newdream.net>
	<1248292313-31326-14-git-send-email-sage@newdream.net>
	<1248292313-31326-15-git-send-email-sage@newdream.net>
	<1248292313-31326-16-git-send-email-sage@newdream.net>
	<1248292313-31326-17-git-send-email-sage@newdream.net>
	<1248292313-31326-18-git-send-email-sage@newdream.net>
Date: Thu, 23 Jul 2009 00:39:25 +0200
In-Reply-To: <1248292313-31326-18-git-send-email-sage@newdream.net> (Sage Weil's message of "Wed, 22 Jul 2009 12:51:51 -0700")
Message-ID: <878wig2vhe.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sage Weil <sage@newdream.net> writes:

> A few Ceph ioctls for getting and setting file layout (striping)
> parameters.

It would be good if you posted manpages for these ioctls
so that the interface can be reviewed. After all
that's intended to be used by applications, isn't it?

There don't seem to be compat ioctl handlers?

> diff --git a/fs/ceph/ioctl.h b/fs/ceph/ioctl.h
> new file mode 100644
> index 0000000..537c27b
> --- /dev/null
> +++ b/fs/ceph/ioctl.h
> @@ -0,0 +1,12 @@
> +#ifndef FS_CEPH_IOCTL_H
> +#define FS_CEPH_IOCTL_H
> +
> +#include <linux/ioctl.h>
> +#include "types.h"
> +
> +#define CEPH_IOCTL_MAGIC 0x97
> +
> +#define CEPH_IOC_GET_LAYOUT _IOR(CEPH_IOCTL_MAGIC, 1, struct ceph_file_layout)
> +#define CEPH_IOC_SET_LAYOUT _IOW(CEPH_IOCTL_MAGIC, 2, struct ceph_file_layout)

How should the application use that if the include file is in fs/ceph?
Should be in include/linux I guess

Also this file should define all the types needed for the interface,
especialy struct ceph_file_layout, but no kernel internal types.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

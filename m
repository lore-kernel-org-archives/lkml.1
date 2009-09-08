Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbZIHXpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbZIHXpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbZIHXpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 19:45:53 -0400
Received: from cobra.newdream.net ([66.33.216.30]:43810 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbZIHXpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 19:45:52 -0400
Date: Tue, 8 Sep 2009 16:45:55 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/20] ceph: ioctls
In-Reply-To: <20090908160509.bcf511dc.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0909081645360.9053@cobra.newdream.net>
References: <1252450601-17610-1-git-send-email-sage@newdream.net>
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
 <20090908160509.bcf511dc.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009, Randy Dunlap wrote:

> On Tue,  8 Sep 2009 15:56:39 -0700 Sage Weil wrote:
> 
> > A few Ceph ioctls for getting and setting file layout (striping)
> > parameters.
> > 
> > Signed-off-by: Sage Weil <sage@newdream.net>
> > ---
> >  fs/ceph/ioctl.c |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/ceph/ioctl.h |   20 +++++++++++
> >  2 files changed, 118 insertions(+), 0 deletions(-)
> >  create mode 100644 fs/ceph/ioctl.c
> >  create mode 100644 fs/ceph/ioctl.h
> 
> 
> > diff --git a/fs/ceph/ioctl.h b/fs/ceph/ioctl.h
> > new file mode 100644
> > index 0000000..56f5e2c
> > --- /dev/null
> > +++ b/fs/ceph/ioctl.h
> > @@ -0,0 +1,20 @@
> > +#ifndef FS_CEPH_IOCTL_H
> > +#define FS_CEPH_IOCTL_H
> > +
> > +#include <linux/ioctl.h>
> > +#include <linux/types.h>
> > +
> > +#define CEPH_IOCTL_MAGIC 0x97
> > +
> > +/* just use u64 to align sanely on all archs */
> > +struct ceph_ioctl_layout {
> > +	__u64 stripe_unit, stripe_count, object_size;
> > +	__u64 data_pool;
> > +};
> > +
> > +#define CEPH_IOC_GET_LAYOUT _IOR(CEPH_IOCTL_MAGIC, 1,		\
> > +				   struct ceph_ioctl_layout)
> > +#define CEPH_IOC_SET_LAYOUT _IOW(CEPH_IOCTL_MAGIC, 2,		\
> > +				   struct ceph_ioctl_layout)
> > +
> > +#endif
> > -- 
> 
> Please also update Documentation/ioctl/ioctl-number.txt

Thanks, I was wondering where that was tracked.

sage

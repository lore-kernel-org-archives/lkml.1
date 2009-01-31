Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZAaAjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZAaAjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 19:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbZAaAj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 19:39:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52182 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbZAaAj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 19:39:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs: Add new pre-allocation ioctls to vfs for compatibility with legacy xfs ioctls
Date: Sat, 31 Jan 2009 01:38:32 +0100
User-Agent: KMail/1.9.9
References: <4980C71F.1010804@ankitjain.org> <20090130162252.7bf9c1f4.akpm@linux-foundation.org>
In-Reply-To: <20090130162252.7bf9c1f4.akpm@linux-foundation.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
Cc: Ankit Jain <me@ankitjain.org>, viro@zeniv.linux.org.uk, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, mfasheh@suse.com, joel.becker@oracle.com,
       ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
       xfs-masters@oss.sgi.com, xfs@oss.sgi.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901310138.34164.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/GODRZ7ZhZoDfTb1DT2vqRkWN5dj4Ddyz24/D
 GkenMI3+brSdwYV+63Ij1VV1D9GRbQycY/2UQh6mPNJ1KK1g0q
 YA7rKVPiPoonOHMmWGR0g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 January 2009, Andrew Morton wrote:
> On Thu, 29 Jan 2009 02:29:11 +0530 Ankit Jain <me@ankitjain.org> wrote:
> > +struct space_resv {
> > +	__s16		l_type;
> > +	__s16		l_whence;
> > +	__s64		l_start;
> > +	__s64		l_len;		/* len == 0 means until end of file */
> > +	__s32		l_sysid;
> > +	__u32		l_pid;
> > +	__s32		l_pad[4];	/* reserve area			    */
> > +};
> > +
> > +#define F_IOC_RESVSP		_IOW('X', 40, struct space_resv)
> > +#define F_IOC_RESVSP64		_IOW('X', 42, struct space_resv)
> 
> Are we sure that the aligment of l_start will be reliably the same
> across all compilers and versions thereof for all time?

On x86, the alignment differs between 32 and 64 bit, otherwise it's ok.
XFS handles the conversion for compat_ioctl in
fs/xfs/linux-2.6/xfs_ioctl32.c. If this becomes a generic file ioctl,
the conversion code should be moved to fs/compat_ioctl.c.

	Arnd <><

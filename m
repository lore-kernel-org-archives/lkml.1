Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbYF3NzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbYF3NzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbYF3Ny6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:54:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbYF3Ny5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:54:57 -0400
Date: Mon, 30 Jun 2008 14:54:33 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "axboe@kernel.dk" <axboe@kernel.dk>,
       "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 0/3] freeze feature ver 1.8
Message-ID: <20080630135433.GA22522@agk.fab.redhat.com>
Mail-Followup-To: Takashi Sato <t-sato@yk.jp.nec.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
References: <20080630212005t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630212005t-sato@mail.jp.nec.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 09:20:05PM +0900, Takashi Sato wrote:
> Currently, ext3 in mainline Linux doesn't have the freeze feature which
> suspends write requests.  So, we cannot take a backup which keeps
> the filesystem's consistency with the storage device's features
> (snapshot and replication) while it is mounted.
> In many case, a commercial filesystem (e.g. VxFS) has
> the freeze feature and it would be used to get the consistent backup.
> If Linux's standard filesytem ext3 has the freeze feature, we can do it
> without a commercial filesystem.
 
Is the following a fair summary?

1. Some filesystems have a freeze/thaw feature.  XFS exports this to
userspace directly through a couple of ioctls, but other filesystems
don't.  For filesystems on device-mapper block devices it is exported to
userspace through the DM_DEV_SUSPEND ioctl which LVM uses.

2. There is a desire to access this feature from userspace on non-XFS
filesystems without having to use device-mapper/LVM.

Alasdair
-- 
agk@redhat.com

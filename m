Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbZIINw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbZIINw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 09:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbZIINw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 09:52:27 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:40129 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZIINw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 09:52:26 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Christoph Hellwig <hch@lst.de>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
References: <c4e36d110908310451t7c238e09u5af112fa3321cc23@mail.gmail.com>
	<200908312119.12121.rjw@sisk.pl>
	<c4e36d110909010234i5f1b9357l805132137725a4f8@mail.gmail.com>
	<c4e36d110909031529q77b53122kdb85785ba293c478@mail.gmail.com>
	<20090903232317.GA6760@lst.de> <87ljkvmt71.fsf@devron.myhome.or.jp>
	<20090908190614.GA18545@lst.de>
Date: Wed, 09 Sep 2009 22:52:26 +0900
In-Reply-To: <20090908190614.GA18545@lst.de> (Christoph Hellwig's message of
	"Tue, 8 Sep 2009 21:06:14 +0200")
Message-ID: <87hbvc5ip1.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> On Fri, Sep 04, 2009 at 09:47:46AM +0900, OGAWA Hirofumi wrote:
>> Well, that commit seems a bit strange. It calls fat_clusters_flush()
>> unconditionally without checking sb->s_dirt. However, if my guess is
>> right, "sync after removed event" itself sounds like the issue in
>> suspend process.
>
> The idea of ->sync_fs is that we always perform the sync activity,
> and not just the usual background superblock writeback trigerred by
> s_dirt.  If FAT doesn't need that and never has races around s_dirt
> you can add the check back, but I would recommend against it.

I'm not sure the detail of your idea of ->sync_fs. "always perform" is
not the goal of it, right?  Anyway, we should consider about unnecessary
write reduces the lifetime of flash base device.

And what races of s_dirt?  ("always perform" fixed those? and why we
gave up to fix the real problems or root-casue?)  Maybe, I already
noticed one of those, but I may not be noticing all of those.  If you
can explain the detail of those known problems, I appreciate and would
be useful.

And write_super() of FAT doesn't affect to fs consistency, it's one of
reasons why I moved it to write_super().

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

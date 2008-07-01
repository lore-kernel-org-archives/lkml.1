Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbYGAIe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbYGAIe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYGAIdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:33:44 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:47271 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757035AbYGAIdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:33:42 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Christoph Hellwig <hch@infradead.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] fat: Fix VFAT_IOCTL_READDIR_xxx and cleanup for userland
References: <9edbdefc3e848699cfe111608.ps@mail.parknet.co.jp>
	<129170883e848699cff211608.ps@mail.parknet.co.jp>
	<20080701074033.GB30362@infradead.org>
Date: Tue, 01 Jul 2008 17:33:36 +0900
In-Reply-To: <20080701074033.GB30362@infradead.org> (Christoph Hellwig's
	message of "Tue, 1 Jul 2008 03:40:33 -0400")
Message-ID: <87zlp2uhpb.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Tue, Jul 01, 2008 at 11:57:03AM +0900, OGAWA Hirofumi wrote:
>> 
>> "struct dirent" is a kernel type here, but is a **different type** in 
>> userspace!  This means both the structure and the IOCTL number is wrong!
>> 
>> So, this adds new "struct __fat_dirent" to generate correct IOCTL
>> number.  And kernel stuff moves to under __KERNEL__.
>
> Given that the current version can't actually work without defininig
> it's own dirent and thus ioctl number symbolic name I wonder if these
> ioctls are used at all?  They must have been completely untested for
> a while, and I suspect we'd be better off just removing them.

I'm not sure whether all users doesn't use. (If user uses correct dirent
like I did to test in past, it generates correct number.)

Anyway, why is it better off?  I think, if users which copied, this
patch shouldn't have any impact, and other users can use fixed version?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

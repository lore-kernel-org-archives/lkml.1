Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbYEPXZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbYEPXZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 19:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYEPXZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 19:25:26 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:57697 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbYEPXZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 19:25:25 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       ezk@cs.sunysb.edu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 07/22] fat: dont call notify_change
References: <20080516163136.560107038@szeredi.hu>
	<20080516163222.235825996@szeredi.hu>
Date: Sat, 17 May 2008 08:25:15 +0900
In-Reply-To: <20080516163222.235825996@szeredi.hu> (Miklos Szeredi's message
	of "Fri, 16 May 2008 18:31:43 +0200")
Message-ID: <87prrl7rxg.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> From: Miklos Szeredi <mszeredi@suse.cz>
>
> The FAT_IOCTL_SET_ATTRIBUTES ioctl() calls notify_change() to change
> the file mode before changing the inode attributes.  Replace with
> explicit calls to security_inode_setattr(), fat_setattr() and
> fsnotify_change().
>
> This is equivalent to the original.  The reason it is needed, is that
> later in the series we move the immutable check into notify_change().
> That would break the FAT_IOCTL_SET_ATTRIBUTES ioctl, as it needs to
> perform the mode change regardless of the immutability of the file.
>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Don't we need to add EXPORT_SYMBOL(security_inode_setattr)? Otherwise,
looks good to me.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbZG0PKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbZG0PKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbZG0PKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:10:52 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:35476 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbZG0PKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:10:49 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: =?iso-8859-1?Q?J=F6rg?= Schummer <ext-jorg.2.schummer@nokia.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH take 2][RFC] fat: Save FAT root directory timestamps to volume label
References: <1248274841-3586-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	<1248428635-26073-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	<87fxclmhxy.fsf@devron.myhome.or.jp>
	<1248691635.4618.43.camel@jorg-desktop>
	<87ljmas5ym.fsf@devron.myhome.or.jp>
	<1248706563.4618.95.camel@jorg-desktop>
Date: Tue, 28 Jul 2009 00:10:48 +0900
In-Reply-To: <1248706563.4618.95.camel@jorg-desktop> (=?iso-8859-1?Q?=22J?=
 =?iso-8859-1?Q?=F6rg?= Schummer"'s
	message of "Mon, 27 Jul 2009 17:56:03 +0300")
Message-ID: <878wia6u13.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörg Schummer <ext-jorg.2.schummer@nokia.com> writes:

> Hello again,
>
> just in case you (or perhaps somebody else) have a minute to assist me..
>
> On Mon, 2009-07-27 at 13:47 +0200, ext OGAWA Hirofumi wrote:
>
>> BTW, the patch has several bugs. fat_get_label_entry() doesn't check
>> IS_FREE(), is it right?
>
> Not 100% sure if it's needed in a consistent fs, but I guess it
> shouldn't do any harm, so I added it.

If label was removed, what happen? I was assumed utility does

    label_de->name[0] = DELETED_FLAG;


>> spin_lock() usage is wrong.
>
>>From the code, I'm not totally sure then what inode_hash_lock is
> supposed to protect in fat_write_inode. Probably it should prevent that
> the dir entry of an inode is being moved around to another i_pos while
> it's being changed?
>
> But in the pre-patch version of fat_write_inode, shouldn't then
> mark_buffer_dirty(bh) be called when the lock is still held?

I meant, read/write of storage might sleep, so it shouldn't hold
spin_lock when does it.

If you set debug CONFIG_* of locking, I guess it will warn.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

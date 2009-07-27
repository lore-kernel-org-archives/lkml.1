Return-Path: <linux-kernel-owner+w=401wt.eu-S1752245AbZG0O4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbZG0O4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZG0O4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:56:17 -0400
Received: from smtp.nokia.com ([192.100.122.230]:26150 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbZG0O4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:56:16 -0400
Subject: Re: [PATCH take 2][RFC] fat: Save FAT root directory timestamps to
	volume label
From: =?ISO-8859-1?Q?J=F6rg?= Schummer <ext-jorg.2.schummer@nokia.com>
To: ext OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <87ljmas5ym.fsf@devron.myhome.or.jp>
References: <1248274841-3586-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	 <1248428635-26073-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	 <87fxclmhxy.fsf@devron.myhome.or.jp>
	 <1248691635.4618.43.camel@jorg-desktop>
	 <87ljmas5ym.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 27 Jul 2009 17:56:03 +0300
Message-Id: <1248706563.4618.95.camel@jorg-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Jul 2009 14:56:02.0878 (UTC) FILETIME=[5C55A5E0:01CA0ECA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

just in case you (or perhaps somebody else) have a minute to assist me..

On Mon, 2009-07-27 at 13:47 +0200, ext OGAWA Hirofumi wrote:

> BTW, the patch has several bugs. fat_get_label_entry() doesn't check
> IS_FREE(), is it right?

Not 100% sure if it's needed in a consistent fs, but I guess it
shouldn't do any harm, so I added it.

> fat_create_label_entry() doesn't initialize all
> timestamp in the case of msdos.

Corrected.

> spin_lock() usage is wrong.

>From the code, I'm not totally sure then what inode_hash_lock is
supposed to protect in fat_write_inode. Probably it should prevent that
the dir entry of an inode is being moved around to another i_pos while
it's being changed?

But in the pre-patch version of fat_write_inode, shouldn't then
mark_buffer_dirty(bh) be called when the lock is still held?

Sorry for the newbie-questions, thanks for any help.

Jörg



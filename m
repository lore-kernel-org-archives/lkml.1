Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYLKGAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYLKGAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 01:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbYLKGAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 01:00:45 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49572 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbYLKGAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 01:00:44 -0500
Date: Thu, 11 Dec 2008 06:00:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nguyen Anh Quynh <aquynh@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Kuniyasu Suzaki <k.suzaki@aist.go.jp>
Subject: Re: [PATCH] fix calls to request_module()
Message-ID: <20081211060041.GN28946@ZenIV.linux.org.uk>
References: <9cde8bff0812101935j5ef56140k67035d892a868738@mail.gmail.com> <20081211040118.GK28946@ZenIV.linux.org.uk> <20081210201455.0c611484.akpm@linux-foundation.org> <9cde8bff0812102023v60ce265bk394c420a29100b92@mail.gmail.com> <20081211050023.GM28946@ZenIV.linux.org.uk> <9cde8bff0812102142s5d58b8dcibe5d36a68e09f367@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cde8bff0812102142s5d58b8dcibe5d36a68e09f367@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 02:42:28PM +0900, Nguyen Anh Quynh wrote:
> > Ah, but that's different.  Take a look at that warning and think _why_
> > it is given and what is it about.  Getting an untrusted string as
> > format argument is a real security hole, but it has nothing to do
> > with a pile of cases in your patch.
> 
> Yes, clearly the warning is to warn us about potential format string
> bugs. But I agree that there are a lot of false possitives.
> 
> My patch is mainly to make gcc happy.

Your patch is mostly obfuscating the places gcc does *not* warn about...

Looking through it, only
drivers/media/video/cx18/cx18-driver.c
drivers/media/video/ivtv/ivtv-driver.c
drivers/media/video/pvrusb2/pvrusb2-hdw.c
drivers/media/video/zoran/zoran_card.c
drivers/mtd/chips/gen_probe.c
drivers/net/wireless/hostap/hostap_ioctl.c
drivers/of/of_spi.c
drivers/usb/storage/libusual.c
fs/dquot.c
fs/gfs2/locking.c
net/ieee80211/ieee80211_wx.c
sound/core/sound.c

are not of <string literal> -> "%s", <string literal> variety.  Everything
else has never generated a format warning.  At least trim the patch,
removing the obviously useless parts.

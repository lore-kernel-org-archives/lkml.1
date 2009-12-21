Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbZLUQx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbZLUQx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZLUQx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:53:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51966 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbZLUQx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:53:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [PATCH] fs/compat_ioctl.c: fix build error when !BLOCK
Date: Mon, 21 Dec 2009 17:53:53 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
References: <1261344092-30700-1-git-send-email-a.beregalov@gmail.com> <20091220212515.GP18217@ZenIV.linux.org.uk> <a4423d670912201353r53ed19cegc5061c3510e6ecf@mail.gmail.com>
In-Reply-To: <a4423d670912201353r53ed19cegc5061c3510e6ecf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912211753.53832.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18rxYnacbEWZLmFW+yPwF8tdEeoRTRkUA5KR6z
 aVRQhpDvndmGURffymMv2iwTmmj1fwNu8rQvEBFKLaXQ36bc5f
 bwRbGnbb8ATvYAD2+5R4g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No driver uses SG_SET_TRANSFORM any more in Linux, since the ide-scsi
driver was removed in 2.6.29. The compat-ioctl cleanup series moved
the handling for this around, which broke building without CONFIG_BLOCK.

Just remove the code handling it for compat mode.
---

On Sunday 20 December 2009, Alexander Beregalov wrote:
> 2009/12/21 Al Viro <viro@zeniv.linux.org.uk>:
> > On Mon, Dec 21, 2009 at 12:21:32AM +0300, Alexander Beregalov wrote:
> >> Fix this build error when CONFIG_BLOCK is not set.
> >> fs/compat_ioctl.c:1604: error: 'SG_SET_TRANSFORM' undeclared
> >
> > Do you want that through VFS tree?  I'm going to send a bunch of assorted
> > fixes tomorrow morning, so I can pass that one at the same time...
> 
> Yes, please.

Sorry for being slow on this, I already had the fix prepared when Randy
found it last week but had not gotten around to submitting it.

Al, the patch that Alexander has sent is obviously correct as well,
so if you have already prepared the series just keep that one, otherwise
please replace it with this one.

--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1600,8 +1600,6 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
 	case KDSKBMETA:
 	case KDSKBLED:
 	case KDSETLED:
-	/* SG stuff */
-	case SG_SET_TRANSFORM:
 	/* AUTOFS */
 	case AUTOFS_IOC_READY:
 	case AUTOFS_IOC_FAIL:

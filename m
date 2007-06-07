Return-Path: <linux-kernel-owner+w=401wt.eu-S1758680AbXFGHJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbXFGHJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbXFGHJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:09:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:8252 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbXFGHJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:09:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=TEgZKLRqHCULdB4DRiI6sglNQiWlLeohZRY5uf4gD3T904Ux/fDO8buIDzvhXBzctw3UCGBMPUbQOHsHfJipN/e0P57QI0Vs5UgRvTaPM/Wj2vMGfvdYiQ+pL37L2eghNfFNQ/8pjIO0HUKTvwboibptYkxcja7vaE5KK/ajl6M=
Message-ID: <4667AF20.4020209@gmail.com>
Date: Thu, 07 Jun 2007 16:09:20 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
References: <200706061421.l56ELDfB004305@harpo.it.uu.se>	<4666D3F8.4010002@gmail.com> <20070606105650.bebf1c95.akpm@linux-foundation.org> <4666FBE8.3030103@gmail.com> <4667A93A.4060608@gmail.com> <4667AD3F.1010405@gmail.com>
In-Reply-To: <4667AD3F.1010405@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
>>>> Here it is - please test?
>>> Ok, this solves this problem, but LVM is broken. Seems similar to
>>> Re: 2.6.22-rc4-mm1 - 'lvm vgscan' busticated again...
>>> Message-ID: <7929.1181146132@turing-police.cc.vt.edu>
>>> Will try to play with this.
>> Did -rc3-mm1 work?

Hmmm... I see.

> Yes. Now I'm compiling -rc4-mm2.

It's probably caused by new sysfs slimdown patches and I'm pretty sure
-rc4-mm2 would fail the same way.  The offending one should be one of
the following patches.

gregkh-driver-sysfs-fix-parent-refcounting-during-rename-and-move.patch
gregkh-driver-sysfs-reorganize-sysfs_new_indoe-and-sysfs_create.patch
gregkh-driver-sysfs-use-iget_locked-instead-of-new_inode.patch
gregkh-driver-sysfs-fix-root-sysfs_dirent-root-dentry-association.patch
gregkh-driver-sysfs-move-s_active-functions-to-fs-sysfs-dirc.patch
gregkh-driver-sysfs-slim-down-sysfs_dirent-s_active.patch
gregkh-driver-sysfs-use-singly-linked-list-for-sysfs_dirent-tree.patch

Can you bisect the above patches?

-- 
tejun

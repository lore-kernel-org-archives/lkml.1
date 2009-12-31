Return-Path: <linux-kernel-owner+w=401wt.eu-S1751691AbZLaGcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbZLaGcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 01:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbZLaGcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 01:32:16 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64065 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZLaGcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 01:32:15 -0500
Date: Wed, 30 Dec 2009 22:32:04 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH 0/5] reiserfs lock inversion fixes on xattr
In-Reply-To: <1262205747-9208-1-git-send-regression-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.01.0912301943020.3483@bogon.housecafe.de>
References: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com> <1262205747-9208-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/okd/VawiyvN3qm2B8MOrZ5Z7ClU6hmwGVwY3
 2+2rUBWCGY5KN71bgyaLH8jJ3JP27oMWwuhhqAwFtfmNk7tKc1
 fVUh3/85CvQDDsVtHoX0w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Dec 2009 at 21:42, Frederic Weisbecker wrote:
> I hope you can give it a try (and/or review) before I send the whole
> to Linus.

Without your patches, "dbench -x" was pretty much instantly causing the 
threads to lock up, forcing me to reboot the box. With LOCKDEP enabled, 
warnings were printed. After applying your patches (and a reboot) I've run 
"dbench -x" for quite a while now with different runtimes and number of
clients and it's not locking up any more. I've tested with:

CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set

...and a few "Kernel hacking" options set. Full config and dmesg:

   http://nerdbynature.de/bits/2.6.33-rc1/reiserfs/t3/

   (although I'm not really testing -rc1 but latest mainline -git
    and your changes pulled)

So, feel free to add:

  Tested-by: Christian Kujau <lists@nerdbynature.de>

I can't help with the code review though :-\

Thanks!
Christian.
-- 
BOFH excuse #208:

Your mail is being routed through Germany ... and they're censoring us.

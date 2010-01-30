Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257Ab0A3WZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab0A3WZb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 17:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175Ab0A3WZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 17:25:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57275 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab0A3WZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 17:25:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Subject: compat_ioctl: ignore RAID_VERSION ioctl
Date: Sat, 30 Jan 2010 23:02:10 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc5; KDE/4.3.2; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, neilb@suse.de,
       linux-raid@vger.kernel.org, dm-devel@redhat.com, maan@systemlinux.org
References: <20100130205353.GA3168@redhat.com>
In-Reply-To: <20100130205353.GA3168@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001302302.10574.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/hqNpTBsikWrhpSJPHV29LKhlEy19MgERXWUD
 s0gn4BKD+HhqQf8abODUbyqGVVQkRLYaFAXK5PS79MbuODs5px
 904/kqObJzqltEeQa/9IQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

md ioctls are now handled by the md driver itself, but mdadm
may call RAID_VERSION on other devices as well. Mark the command
as IGNORE_IOCTL so this fails silently rather than printing
an annoying message.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---

On Saturday 30 January 2010, Michael S. Tsirkin wrote:
> Under 2.6.33-rcX (at least rc5 and rc6, didn't check earlier versions),
> I started seeing these messages in dmesg (I do not see these messages on 2.6.32):
> 
> [   16.528951] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9c4) on /dev/sda9

Does this help?

--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1038,6 +1038,8 @@ COMPATIBLE_IOCTL(FIOQSIZE)
 #ifdef CONFIG_BLOCK
 /* loop */
 IGNORE_IOCTL(LOOP_CLR_FD)
+/* md calls this on random blockdevs */
+IGNORE_IOCTL(RAID_VERSION)
 /* SG stuff */
 COMPATIBLE_IOCTL(SG_SET_TIMEOUT)
 COMPATIBLE_IOCTL(SG_GET_TIMEOUT)


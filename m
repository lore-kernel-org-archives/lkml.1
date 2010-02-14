Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0BNXWw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 18:22:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60436 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab0BNXWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 18:22:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jouni Malinen <j@w1.fi>
Subject: Re: 2.6.33-rc8 breaks UML with Restrict initial stack space expansion to rlimit
Date: Mon, 15 Feb 2010 00:23:27 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: Michael Neuling <mikey@neuling.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
References: <20100214164023.GA2726@jm.kir.nu>
In-Reply-To: <20100214164023.GA2726@jm.kir.nu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002150023.27908.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 February 2010, Jouni Malinen wrote:
> It looks like the commit 803bf5ec259941936262d10ecc84511b76a20921
> (fs/exec.c: restrict initial stack space expansion to rlimit) broke my
> user mode Linux setup by somehow preventing system setup from running
> properly (or killing some processes that try to mount things, etc.).
> This commit turned up as the reason based on git bisect and reverting it
> fixes my UML test setup (Ubuntu 9.10 on both host and in UML and AMD64
> arch for both). I have no idea what exactly would be the main cause for
> this issue, but this looks like a somewhat unfortunately timed
> regression in 2.6.33-rc8.
> 
> The failed run shows like this (with current linux-2.6.git):
> 
> ...
> EXT3-fs (ubda): mounted filesystem with writeback data mode
> VFS: Mounted root (ext3 filesystem) readonly on device 98:0.
> IRQ 3/console-write: IRQF_DISABLED is not guaranteed on shared IRQs
> IRQ 2/console: IRQF_DISABLED is not guaranteed on shared IRQs
> IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> mountall: mount /sys/kernel/debug [218] killed by KILL signal
> mountall: Filesystem could not be mounted: /sys/kernel/debug
> mountall: mount /dev [219] killed by KILL signal
> mountall: Filesystem could not be mounted: /dev
> mountall: mount /tmp [220] killed by KILL signal
> mountall: Filesystem could not be mounted: /tmp
> mountall: mount /var/lock [222] killed by KILL signal
> mountall: Filesystem could not be mounted: /var/lock
> ...
> 
> 
> With 803bf5ec reverted, UML comes up and the output looks like this:
> 
> ...
> EXT3-fs (ubda): mounted filesystem with writeback data mode
> VFS: Mounted root (ext3 filesystem) readonly on device 98:0.
> IRQ 3/console-write: IRQF_DISABLED is not guaranteed on shared IRQs
> IRQ 2/console: IRQF_DISABLED is not guaranteed on shared IRQs
> IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> init: procps main process (226) terminated with status 255
> fsck from util-linux-ng 2.16
> ...

I have created the Bugzilla entry at http://bugzilla.kernel.org/show_bug.cgi?id=15308
for your report.

Thanks,
Rafael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbXJCIuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbXJCIuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 04:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbXJCIub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 04:50:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48804 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbXJCIua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 04:50:30 -0400
Date: Wed, 3 Oct 2007 10:50:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Alexander Viro <viro@ftp.linux.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] crash when reading /proc/mounts (was: Re: Linux
	2.6.23-rc9 and a heads-up for the 2.6.24 series..)
Message-ID: <20071003085022.GA6672@elte.hu>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <20071003084607.GC32218@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003084607.GC32218@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


update: occasionally the reading of /proc/mounts succeeds, and it's:

 open("/proc/mounts", O_RDONLY|O_LARGEFILE) = 3
 fstat64(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
 read(3, "rootfs / rootfs rw 0 0\n/dev/root"..., 4096) = 290
 write(1, "rootfs / rootfs rw 0 0\n/dev/root"..., 290rootfs / rootfs rw 0 0
 /dev/root / ext3 rw,noatime,nodiratime,data=ordered 0 0
 /proc /proc proc rw 0 0
 /proc/bus/usb /proc/bus/usb usbfs rw 0 0
 /sys /sys sysfs rw 0 0
 /dev/devpts /dev/pts devpts rw 0 0
 /dev/sda2 /home ext3 rw,noatime,nodiratime,data=ordered 0 0
 nodev /debug debugfs rw 0 0
 ) = 290
 read(3, "", 4096)                       = 0
 close(3)                                = 0

there's nothing particularly interesting in it. (perhaps debugfs)

	Ingo

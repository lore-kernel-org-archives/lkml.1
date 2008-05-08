Return-Path: <linux-kernel-owner+w=401wt.eu-S1761521AbYEHJNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761521AbYEHJNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 05:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761104AbYEHJNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 05:13:40 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:41046 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761100AbYEHJNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 05:13:39 -0400
Date: Thu, 8 May 2008 11:13:37 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, adaplas@pol.net, hpa@zytor.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: 2.6.26-rcX VC console scrolling regression
In-Reply-To: <20080507.214637.193700986.davem@davemloft.net>
Message-ID: <alpine.LNX.1.10.0805081049510.16904@fbirervta.pbzchgretzou.qr>
References: <20080507.214637.193700986.davem@davemloft.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-05-08 06:46, David Miller wrote:
>
>Causes garbage characters to appear at the end of lines on my VCs when
>scrolling.
>
>They look like lowercase 'c' characters with a '.' above them, and they
>are colored light blue.  The rest of the console text is fine.

i386 or sparc64?

In trying to reproduce it, Ubuntu already died on me (insert big rant
here) and I have no idea how to fix that if I want to keep the
stockness of the install:

-->>>--
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Cache data unavailable
sd 2:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1 sdb2 < sdb5 >
sd 2:0:0:0: [sdb] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
Done.
Begin: Running /scripts/local-premount ...
Done.
mount: Mounting /dev/sdb1 on /root failed: No such device
Begin: Running /scripts/local-bottom ...
Done.
Done.
Begin: Running /scripts/init-bottom ...
mount: Mounting /root/dev on /dev/.static/dev failed: No such file or directory.
Done.
mount: Mounting /sys on /root/sys failed: No such file or directory
mount: Mounting /proc on /root/proc failed: No such file or directory
Target filesystem doesn't have /sbin/init


BusyBox v1.1.3 (Debian 1:1.1.3-5ubuntu7) Built-in shell (ash)
Enter 'help' for a list of built-in commands.

(initramfs)
---<<<---


>I think it might be because my VC gets put into a UTF8 mode or something
>like that via the init scripts?

opensuse also switches to utf8 (though noting that the kernel starts
with utf8 by default since 2.6.24) and I have not noticed anything bad.

Are you using a serial console?

>  It seems to start happening right when
>the init scripts print "Setting up console font and keymap", which seems
>to come from /etc/init.d/console-setup which runs /bin/setupcon
>
>This is with a stock Ubuntu 7.10 installation.
>

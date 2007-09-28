Return-Path: <linux-kernel-owner+w=401wt.eu-S1760035AbXI1Jdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035AbXI1Jdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbXI1JdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:33:25 -0400
Received: from sargon.lncsa.com ([212.99.8.251]:58234 "EHLO sargon.lncsa.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbXI1JdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:33:24 -0400
Message-ID: <46FCC2BE.7020509@lncsa.com>
Date: Fri, 28 Sep 2007 11:00:46 +0200
From: Laurent CARON <lcaron@lncsa.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: drbd-user@linbit.com
Subject: Crash on 2.6.22
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I did experience a quite strange problem (at least for me) on the first
node of our 2 node cluster.

This is basically an imap/smtp/http proxy server.

One of the imapd processes started to use a lot of cpu, memory... this
morning.

Oomkiller showed up and killed slapd, imapd, amavisd....

I then restarted those processes manually, and it went fine.

A few moments later i got the following messages on my ssh terminal:

kernel: Bad page state in process 'swapper'
kernel: Bad page state in process 'swapper'
kernel: page:c1032a40 flags:0x40000400 mapping:00000000 mapcount:0 count:0
kernel: page:c1032a40 flags:0x40000400 mapping:00000000 mapcount:0 count:0
kernel: Trying to fix it up, but a reboot is needed
kernel: Trying to fix it up, but a reboot is needed
kernel: Backtrace:
kernel: Backtrace:
kernel: Bad page state in process 'swapper'
kernel: Bad page state in process 'swapper'
kernel: page:c1032a40 flags:0x40000400 mapping:00000000 mapcount:0 count:0
kernel: page:c1032a40 flags:0x40000400 mapping:00000000 mapcount:0 count:0
kernel: Trying to fix it up, but a reboot is needed
kernel: Trying to fix it up, but a reboot is needed
kernel: Backtrace:
kernel: Backtrace:


The machine then completely locked, and did reboot (thanks to the watchdog).

This server is a HP DL380G5 with 12Gb memory, 8 SAS Disks, .... a quite
standard box.


The $HOME directories are stored on a drbd (version: 0.7.24
(api:79/proto:74)) partition (with an XFS filesystem).

The only 'non standard' thing I did use is a swap file instead of a swap
partition.

$ free             total       used       free     shared    buffers
 cached
Mem:      12471932    7420364    5051568          0       3984    6680868
-/+ buffers/cache:     735512   11736420
Swap:       393208          0     393208


$ grep swap /etc/fstab
/var/tmp/swapfile swap    swap    defaults    0   0


Might this be the (or one of the) cause of this problem ?

.config is available here: http://zenon.apartia.fr/stuff/config-2.6.22

Thanks

Laurent

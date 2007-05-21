Return-Path: <linux-kernel-owner+w=401wt.eu-S1759893AbXEUIzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893AbXEUIzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbXEUIzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:55:07 -0400
Received: from main.gmane.org ([80.91.229.2]:56173 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755724AbXEUIzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:55:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: John Miller <forall@mail15.com>
Subject: UDP packet loss when running lsof
Date: Mon, 21 May 2007 08:51:05 +0000 (UTC)
Message-ID: <loom.20070521T090409-252@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 62.225.145.226 ()
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm experiencing silent (no counter increased or log message) UDP
packet loss inside the kernel (2.6.16.27 from Novell).

My application receives about 50 MB of multicast UDP traffic and
writes the packets into files. If I comment out the write() call,
the application runs for days without packet loss. With the write()
at some random times (20 minuntes or even hours) blocks of packets
(from 10 to 300) are lost.

While I can run 10 "while true; do true; done" or a "dd" that writes
additional data to disk without any effect on the packet loss, a
simple "lsof" forces packet loss most of the time.

Are there any more configuration options of the kernel that will
help? Which system calls of lsof are blocking the network data
throughput of the kernel?

Some background about the things I already did:

- I increased the max allowed receive buffer through
proc/sys/net/core/rmem_max and the application calls the right
syscall. "netstat -su" does not show any "packet receive errors".

- After getting "kernel: swapper: page allocation failure.
order:0, mode:0x20", I increased /proc/sys/vm/min_free_kbytes

- ixgb.txt in kernel network documentation suggests to increase
net.core.netdev_max_backlog to 300000. This did not help.

- I also had to increase net.core.optmem_max, because the default
value was too small for 700 multicast groups.

- Network card is handled by bnx2 kernel module

- The application uses multiple threads for receiving and writing,
so the receiver threads can still receive while the writer threads
are waiting for I/O completions.

TIA for any help and suggestions.
JM



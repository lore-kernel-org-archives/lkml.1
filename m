Return-Path: <linux-kernel-owner+w=401wt.eu-S965145AbXBYVsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965145AbXBYVsA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 16:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965149AbXBYVsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 16:48:00 -0500
Received: from fb2.tech.numericable.fr ([82.216.111.50]:35666 "EHLO
	fb2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965145AbXBYVr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 16:47:59 -0500
X-Greylist: delayed 1230 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Feb 2007 16:47:59 EST
Message-ID: <45E1FFCC.50201@free.fr>
Date: Sun, 25 Feb 2007 22:29:48 +0100
From: John <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org,
       tglx@timesys.com, linux.kernel@free.fr, akpm@linux-foundation.org
Subject: CLOCK_MONOTONIC datagram timestamps by the kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It is possible to ask Linux to timestamp incoming datagrams when they
are received, then to retrieve this timestamp with an ioctl command or
a recvmsg call (which would save one round trip to kernel space).

SIOCGSTAMP
     Return a struct timeval with the receive timestamp of the last
packet passed to the user. This is useful for accurate round trip time
measurements. See setitimer(2) for a description of struct timeval.

As far as I understand, this timestamp is given by the CLOCK_REALTIME
clock. I would like to get the timestamp given by a different clock: the
CLOCK_MONOTONIC clock.

In other words, I would like the kernel to do the equivalent of

   struct timespec spec;
   clock_gettime(CLOCK_MONOTONIC, &spec)

for each datagram the system receives, as soon as it is received.

Is there a way to achieve that?

Is there a different ioctl perhaps? (I don't think so.)

Regards.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1765426AbZEAU01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765426AbZEAU01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZEAU0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:26:18 -0400
Received: from mail.litespeedtech.com ([64.18.140.195]:49499 "EHLO
	mail.litespeedtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZEAU0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:26:18 -0400
X-Greylist: delayed 1225 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 May 2009 16:26:18 EDT
Message-ID: <49FB5612.3090409@litespeedtech.com>
Date: Fri, 01 May 2009 16:05:38 -0400
From: George Wang <gwang@litespeedtech.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: mmap() call blocks on Disk I/O?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.0 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trouble shooting some disk I/O performance issues and have an
interesting finding.

The project is to improve event-driven web server performance in disk
bound situation by avoiding blocking on disk I/O.
We use separate threads to do disk I/O tasks, so we expect the main
thread wont be badly affected by disk I/O, but it still is.
I use strace to locate the sys-calls that block the main server thread
when server is doing disk I/O intensive tasks.

The finding is mmap() calls. we map files in 128KB memory blocks in the
main thread.

When disk I/O is low, mmap() usually takes 0.00002 second to complete,
when the disk getting busy, it takes about 0.01 second to
complete,  if there are multiple disk I/O tasks making the disk seeks
back and forth. mmap could take 0.1 second and up, the worst number we
get is 1.4 seconds.

Noticed that there is a patch to improve the multi-thread mmap()
performance, it should not be the same issue as we have met, I believe.

Just want to report this issue and hope it is helpful to improve the
kernel.

OpenSuse 11.0 with kernel 2.6.22.19-0.2-default, dual Intel Xeon 5410
(8-cores) with 8GB memory.

Thanks,
George Wang


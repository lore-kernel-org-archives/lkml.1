Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbXILXQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbXILXQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 19:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbXILXQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 19:16:33 -0400
Received: from mail.nagafix.co.uk ([194.145.196.85]:40334 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbXILXQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 19:16:32 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Sep 2007 19:16:31 EDT
Message-ID: <46E871FE.9010908@nagafix.co.uk>
Date: Thu, 13 Sep 2007 00:10:54 +0100
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20070806)
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: CFS: some bad numbers with Java/database threading
X-Enigmail-Version: 0.95.2
OpenPGP: id=F18AD6BB;
	url=http://users.nagafix.co.uk/~antoine/antoine.asc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hi list,

I was working on some unit tests and thought I'd give CFS a whirl to see
if it had any impact on my workloads (to see what the fuss was about),
and I came up with some pretty disturbing numbers:
http://devloop.org.uk/documentation/database-performance/Linux-Kernels/Kernels-ManyThreads-CombinedTests-noload2.png
As above but also showing the load average:
http://devloop.org.uk/documentation/database-performance/Linux-Kernels/Kernels-ManyThreads-CombinedTests2.png
Looks like a regression to me...

Basically, all the previous kernels are pretty close (2.6.16 through to
2.6.20 performed almost identically to 2.6.22 and are not shown here to
avoid cluttering the graphs)

All the 2.6.23-rc kernels performed poorly (except -rc3!): much more
erratically and with a sharp performance drop above 800 threads. The
load starts to go up and the performance takes a nosedive.

With fewer threads (less than 50) there is hardly any difference at all
between all the kernels.

Notes about the tests and setup:
* environment is:
Dual Opteron 252 with 3GB ram, scsi disk, etc..
Sun Java 1.6
MySQL 5.0.44
Junit + ant + my test code (devloop.org.uk)
* java threads are created first and the data is prepared, then all the
threads are started in a tight loop. Each thread runs multiple queries
with a 10ms pause (to allow the other threads to get scheduled)
* load average is divided by the number of cpus (2)
* more general information (which also covers some irrelevant
information about some other tests I have published) is here:
http://devloop.org.uk/documentation/database-performance/Setup/

Don't shoot the messenger!
I can run some more tests if needed (bearing in mind that a full test
run takes a few hours) or you can run the tests yourself: instructions
on running the tests are included.
I am now re-testing with sched-cfs-v2.6.23-rc6-v21-combo-2.patch
but feel free to send some other patches.

Antoine
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG6HH+GK2zHPGK1rsRCl3oAJ9c4crCtNQfGs9gWO7Y5CvcIno8TACbBPTw
0TEHkqLMGAfH0ILwWVKc0oo=
=1iBA
-----END PGP SIGNATURE-----

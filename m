Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbYAYMA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbYAYMA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 07:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbYAYMAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 07:00:16 -0500
Received: from kunder-beta.interhost.no ([80.239.54.124]:60686 "EHLO
	kunder-beta.interhost.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYAYMAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 07:00:15 -0500
X-Greylist: delayed 1673 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2008 07:00:14 EST
Message-ID: <4799C8E8.9060501@ifi.uio.no>
Date: Fri, 25 Jan 2008 12:32:56 +0100
From: Asbjorn Sannes <asbjorsa@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (X11/20071217)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Unpredictable performance
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am experiencing unpredictable results with the following test
without other processes running (exception is udev, I believe):
cd /usr/src/test
tar -jxf ../linux-2.6.22.12
cp ../working-config linux-2.6.22.12/.config
cd linux-2.6.22.12
make oldconfig
time make -j3 > /dev/null # This is what I note down as a "test" result
cd /usr/src ; umount /usr/src/test ; mkfs.ext3 /dev/cc/test
and then reboot

The kernel is booted with the parameter mem=81920000

For 2.6.23.14 the results vary from (real time) 33m30.551s to 45m32.703s
(30 runs)
For 2.6.23.14 with nop i/o scheduler from 29m8.827s to 55m36.744s (24 runs)
For 2.6.22.14 also varied a lot.. but, lost results :(
For 2.6.20.21 only vary from 34m32.054s to 38m1.928s (10 runs)

Any idea of what can cause this? I have tried to make the runs as equal
as possible, rebooting between each run.. i/o scheduler is cfq as default.

sys and user time only varies a couple of seconds.. and the order of
when it is "fast" and when it is "slow" is completly random, but it
seems that the results are mostly concentrated around the mean.

--
Asbjørn Sannes


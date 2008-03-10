Return-Path: <linux-kernel-owner+w=401wt.eu-S1751812AbYCJJsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbYCJJsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 05:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbYCJJsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 05:48:11 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:20579 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYCJJsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 05:48:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qzKv+88efNd/HWdN61haHwt72M3cEXNNbEp33fsMKm7+VYeC0EdNeH1WMDrs82KpUv7vgRzGKRh3dmS1nutO/WkfyI4MY2ou8JON295f/n9J+VG05p65rJ0b6rvFtssmMAPPiPuNBadV69JIsbFZILTaWj4EKA3Evlq2ssxkMRE=
Message-ID: <2d42915c0803100248r4eb1361exe5f248e39e4187c3@mail.gmail.com>
Date: Mon, 10 Mar 2008 12:48:09 +0300
From: "Kirill Kuvaldin" <kirill.kuvaldin@gmail.com>
To: oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: couldn't get kernel profiling data from OProfile
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using oprofile 0.9.3 on Debian Lenny, kernel 2.6.22 SMP x86_64.

The problem I'm dealing with is that opreport couldn't provide
profiling data for the kernel image.

I start the profiler as follows, specifying the vmlinux image:

kkuvaldin@002:oprofile% sudo opcontrol --vmlinux=/boot/vmlinux
kkuvaldin@002:oprofile% sudo opcontrol --start
Using default event: CPU_CLK_UNHALTED:100000:0:1:1
Using 2.6+ OProfile kernel interface.
Reading module info.
Using log file /var/lib/oprofile/samples/oprofiled.log
Daemon started.
Profiler running.

Then I did some workload to make sure oprofile gets enough samples:

kkuvaldin@002:oprofile% dd if=/dev/urandom of=/dev/null
80870+0 records in
80869+0 records out
41404928 bytes (41 MB) copied, 6.04975 seconds, 6.8 MB/s

kkuvaldin@002:oprofile% sudo opcontrol --stop
Stopping profiling.

However when I tried to get some profiling data for the kernel binary,
I ended up with the following:

kkuvaldin@002:oprofile% sudo opreport -l /boot/vmlinux
error: no sample files found: profile specification too strict ?
zsh: exit 1     sudo opreport -l /boot/vmlinux


I double checked that /boot/vmlinux is the exact image that was
running on the system.


Any ideas why oprofile doesn't list samples for the vmlinux image?



Thanks,
Kirill

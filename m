Return-Path: <linux-kernel-owner+w=401wt.eu-S933032AbZLMC3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbZLMC3c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 21:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932216AbZLMC3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 21:29:32 -0500
Received: from qmta04.westchester.pa.mail.comcast.net ([76.96.62.40]:36172
	"HELO QMTA04.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932214AbZLMC3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 21:29:32 -0500
Date: Sat, 12 Dec 2009 11:39:27 -0500
From: Frank Peters <frank.peters@comcast.net>
To: linux-kernel@vger.kernel.org
Subject: Microcode Module Hangs - Won't Load Microcode
Message-Id: <20091212113927.398ef513.frank.peters@comcast.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not a new problem.  I do not recall exactly when I first noticed
it but it has existed for at least a few years.  The issue is not serious
and thus I have not reported it previously.

Whenever I load the microcode module using modprobe, the process seems
to hang and requires about four minutes to complete.  After the module
is finally loaded, the microcode data cannot be installed to the CPU using
the microcode_ctl utility. 

Here is the kernel log after executing "modprobe microcode."  My machine
is a Core 2 Quad and has four CPU's.

Dec 11 23:24:25 (none) kernel: microcode: CPU0 sig=0x6fb, pf=0x10, revision=0xb6
Dec 11 23:24:25 (none) kernel: platform microcode: firmware: requesting intel-ucode/06-0f-0b
Dec 11 23:25:25 (none) kernel: microcode: CPU1 sig=0x6fb, pf=0x10, revision=0xb6
Dec 11 23:25:25 (none) kernel: platform microcode: firmware: requesting intel-ucode/06-0f-0b
Dec 11 23:26:25 (none) kernel: microcode: CPU2 sig=0x6fb, pf=0x10, revision=0xb6
Dec 11 23:26:25 (none) kernel: platform microcode: firmware: requesting intel-ucode/06-0f-0b
Dec 11 23:27:25 (none) kernel: microcode: CPU3 sig=0x6fb, pf=0x10, revision=0xb6
Dec 11 23:27:25 (none) kernel: platform microcode: firmware: requesting intel-ucode/06-0f-0b
Dec 11 23:28:25 (none) kernel: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba

Notice that there is a one minute wait for each CPU.  This should not
be happening.

Furthermore, the log indicates that the microcode module is successfully loaded,
but yet no microcode data can be installed using the command:

microcode_ctl -f /etc/microcode.dat

The result of the command reports that the microcode data has been loaded
but the kernel log shows nothing when it should indicate a successful install.
Also, the same command can be repeated again and again and it will always
report that new microcode data has been loaded. This behavior indicates that
the microcode data has not been loaded.

Currently I am using kernel 2.6.32 but this problem has been observed
for several previous versions (how far back it goes I cannot be certain).

What can be done to solve or debug this issue?

As I mentioned, the problem is not serious, but the microcode driver
should function as advertised.

Please CC to "frank.peters at comcast.net" as I am not subscribed
to the list.

Frank Peters

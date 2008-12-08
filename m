Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbYLHGTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbYLHGTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 01:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYLHGTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 01:19:14 -0500
Received: from main.gmane.org ([80.91.229.2]:44255 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbYLHGTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 01:19:13 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger@wizards.de>
Subject: Nasty regression from .27.7 to .27.8: idle samba goes crazy
Date: Mon, 08 Dec 2008 07:18:59 +0100
Organization: The Fists of the White Lotus
Message-ID: <pan.2008.12.08.06.18.57.357875@wizards.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: port-87-234-136-62.dynamic.qsc.de
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I just encountered a nasty symptom for the second time that has started to
occur after updating my home server from vanilla 2.6.27.7 to .8 (same
config).

A while after disconnecting a samba client, the smbd samba server
process goes crazy and consumes 100% CPU. From that time on it is
unkillable (kill -9 returns but the process continues to run). The only
recourse is reboot, which works without problem (i.e. unmounting the
served filesystems is apparently possible?). I tried to attach to the
process with gdb but that just hung.

The system is a generic old single-core P4 box with a single SATA drive,
Gentoo userland and Samba is 3.0.33 (in async mode). The kernel has no
patches or binary drivers. It has been rock solid before the update and
shows no other signs of weirdness in logs or otherwise. I downgraded to .7
for now and will see what happens, but since it worked before I am certain
that this is a regression in the .8 release.

The only commonality is a log entry by samba that seems to correlate with
both occurrences:

[2008/12/08 01:02:52, 0] lib/util_sock.c:read_data(534)
  read_data: read failure for 4 bytes to client 192.168.100.128. Error = No route to host

.128 is the Windows client machine (connected via a stable GigE link),
which I shut down pretty much exactly 30 minutes before that (any 30
minute timeouts in the kernel/network stack?). Both instances of these log
entries correlate with the CPU spikes which I noticed in my MRTG graphs.

Any suspects or ideas?

thanks
Holger



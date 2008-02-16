Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbYBPRg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbYBPRg5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 12:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbYBPRgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 12:36:48 -0500
Received: from main.gmane.org ([80.91.229.2]:33588 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654AbYBPRgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 12:36:45 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Gunter Ohrner <G.Ohrner@post.rwth-aachen.de>
Subject: Understanding Block Device Behaviour
Date: Sat, 16 Feb 2008 18:37:10 +0100
Message-ID: <fp76uu$9eh$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: bras-co-85-197-3-127.westend.de
User-Agent: KNode/0.10.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Maybe someone on this list can shed some light on my following observations.
I have a machine running Linux (2.6.23 / 2.6.24) as its main OS, a Windows
XP test installation on a physical primary partition and one logical drive
formatted as VFAT32 for exchanging data (/dev/sda11 / "d:").

I'm running the Windows inside QEMU/KVM, using "-hda /dev/sda" to provide my
physical disk to the VM. Of course, sda11 is never mounted if I start the
VM.

My expectation was that it should work fine to mount sda11, copy files to
it, umount sda11, start the VM, and access the files from there.

Short story: To my surprise this doesn't work, and I'd like to know the
reason, just out of curiosity.

Symptoms are that the freshly copied files do not show up in Windows in the
VM and chkdsk (sometimes) reports data corruption. (Reminder: sda11 had
been unmounted before starting the VM.)
If I shut down the VM and mount sda11 in Linux again, the files are gone
from there as well.

If I mount sda11 again immediately after copying and umounting and without
starting the VM in between, the files show up just fine. If I really shut
of Linux and boot my Windows test installation natively, the files are also
visible and working ok.

I've both tried to format sda11 using mkdosfs and within Windows itself, and
made sure to run chkdsk regularily to avoid suprious follow-up filesystem
errors during my tests.

Why doesn't it work as I expected?

Greetings,

  Gunter


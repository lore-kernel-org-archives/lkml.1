Return-Path: <linux-kernel-owner+w=401wt.eu-S1758784AbZJMLdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbZJMLdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755147AbZJMLdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:33:54 -0400
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:35399 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbZJMLdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:33:53 -0400
X-Greylist: delayed 1919 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Oct 2009 07:33:53 EDT
Subject: (Solved) Problem compile kernel on Ubuntu and using on Debian
From: Jesper Dangaard Brouer <hawk@comx.dk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain
Organization: ComX Networks A/S
Date: Tue, 13 Oct 2009 13:01:17 +0200
Message-Id: <1255431677.13607.118.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Oct 2009 11:01:17.0580 (UTC) FILETIME=[7D103CC0:01CA4BF4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Google,

I had a problem compile kernel 2.6.31.3 on an Ubuntu 9.04 server (CPU
core i7) and using it on a Debian 5.0.3 lenny (CPU Atom 330).  Both
systems using the 64-bit version of the OS'es.  And kernel compiled
for x86_64.

Problems seen:
 "Waiting for root file system..."

If you get past this one, by compiling enough modules into the kernel,
BUT then a lot of modules does not seem to be loaded (modprobe).

Solution:

The solution seems to be related to the modules.dep files generated on
the Ubuntu system and copied to the debian system.

Run the following commands on the debian system:

 depmod -a              2.6.31.3-ubuntu-compiled
 update-initramfs -u -k 2.6.31.3-ubuntu-compiled
 update-grub2

Which means:
 1. update the modules.dep files
 2. recreate the initrd.img
 3. update the grub config

Q: I don't know why a depmod update is required, anyone feel free to answer that question?



Ubuntu 9.04:
 depmod -V
     module-init-tools 3.7-pre9
 gcc --version
     gcc (Ubuntu 4.3.3-5ubuntu4) 4.3.3

Debian lenny:
 depmod -V
     module-init-tools 3.4
 gcc --version
     gcc (Debian 4.3.2-1.1) 4.3.2


My reason for compiling on the Ubuntu system, is that its CPU is a
Core i7, which can compile the kernel in 5 minuts where the Debian
systems has a ATOM 330 CPU which uses 58 minuts to compile the same
kernel...

-- 
Med venlig hilsen / Best regards
  Jesper Brouer
  ComX Networks A/S
  Linux Network developer
  Cand. Scient Datalog / MSc.
  Author of http://adsl-optimizer.dk
  LinkedIn: http://www.linkedin.com/in/brouer


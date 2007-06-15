Return-Path: <linux-kernel-owner+w=401wt.eu-S1759181AbXFOXBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181AbXFOXBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756954AbXFOXBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:01:09 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:8255 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756900AbXFOXBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:01:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=A6YZOVPZUewynAGwwuZkTyR95QgxGNGkeLVwD1Pbgfr3hmPUpemoFiaz7tV+nKJ+Dmf1NgcYySPCXfgJ6J+UsengBHd3z2VbfdAHWzKXSIvx4ufIL26/0zV+C2480BphEVATZvBQ/7WegjIPRv6EIU2t5blNHswFfAnc/lUad2I=
Message-ID: <5cc017590706151601w6233e32bs25a162ddf96d7e2f@mail.gmail.com>
Date: Fri, 15 Jun 2007 19:01:07 -0400
From: Jate <jate.sujj@gmail.com>
To: linux-kernel@vger.kernel.org, jate.sujj@gmail.com
Subject: RAID1 iowait slow writes
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have six identical ATA6 drives in my linux 2.6.17.9 kernel machine.
It is an AMD64 3500 with 2 GB of RAM. There are 3 IDE controllers
(onboard nForce3 IDE, PCI HPT370, and PCI PDC20269). All drives are
masters on lone cables. There are three RAID1 arrays, one on the
drives attached to the NFORCE3 controller, and two staggered across
the HPT370 and PDC20269. DMA is on.

For comparison, I can copy a 1.5GB file in 2 minutes across a single
disk on a different machine. This takes ~3-4 minutes on the software
RAID system. I am expecting 40MB/s on my six ATA6 drives (guessed from
hdparm -t).

I did this while monitoring using iostat. First, a read runs at around
50MB/s on md1 with half on component drives hda & hdc. While this
happens, sporadic writes to the destination occur at a much lower
throughput (no staggered writes on RAID1). After the 1.5GB entire file
is read (cached) into memory, md2 (the destination RAID) shows a very
high kB_wrtn/s for a few seconds. Then, the destination drives in md2
show a low speed write at ~16MB/s for a long time. The top command
shows a high iowait during all these reads and writes.

This characterizes what I've been seeing during long chains of file
i/o operations on the system. Doing stuff like copying a source tree
and checking CVS out to the local disk causes similar slowdowns.
Should the kernel be caching the entire file during the read, and then
slowly writing it out? I believe the whole thing is cached because a
second cp on a large file immediately exits while the RAID subsystem
writes it at slow speed with no reads.

Do you think this has to do with PCI bus saturation?

- Jate Sujjavanich
Please cc me on reply

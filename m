Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab0APSCg (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 13:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594Ab0APSCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 13:02:35 -0500
Received: from khc.piap.pl ([195.187.100.11]:60379 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab0APSCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 13:02:34 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Seth Heasley <seth.heasley@intel.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.32.3] ahci: AHCI and RAID mode SATA patch for Intel  Cougar Point DeviceIDs
References: <201001121700.18234.seth.heasley@intel.com>
	<4B4D4EAA.2010109@gmail.com> <4B4DAA68.60608@pobox.com>
	<m3my0i6nou.fsf@intrepid.localdomain> <4B4DFE1A.4000606@pobox.com>
	<m3iqb57ts7.fsf@intrepid.localdomain>
	<51f3faa71001131557n52e34260k13bf1fe3057bb0e@mail.gmail.com>
	<m3iqb4iwb4.fsf@intrepid.localdomain>
	<51f3faa71001141615n5776454cwbf6787b7a7fb0081@mail.gmail.com>
	<m3iqb3rqmz.fsf@intrepid.localdomain>
	<51f3faa71001151732s77c198bdu1268879afadd2308@mail.gmail.com>
Date: Sat, 16 Jan 2010 19:02:31 +0100
In-Reply-To: <51f3faa71001151732s77c198bdu1268879afadd2308@mail.gmail.com>
	(Robert Hancock's message of "Fri, 15 Jan 2010 19:32:34 -0600")
Message-ID: <m3vdf26i88.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock <hancockrwd@gmail.com> writes:

> Hmm.. From those test results I really suspect some kind of hardware
> fault. Could be a defective motherboard - I don't know if that chip
> needs any terminating resistors on the motherboard for the SATA signal
> lines or something, if so, could be they weren't installed properly..

Unfortunately I can't find a JMB363 datasheet on the net, but there is
a certain mb (p965t-a) schematic available.
It seems JMB363 doesn't need terminators on SATA RX/TX lines, there is
capacitative coupling only (10 nF in each line).

The port in question (SATA#2) on my mb (P45 Neo2) uses pins 56 (RXP)
57 (RXN) and 60 (TXN) 61 (TXP). No visible irregularity, the traces look
like they should, go straigt to the capacitors, and then to 0R R-packs
and to the connector. It looks exactly the same for both ports. There is
no short circuit past the capacitors (from the connector side). I'd say
quite low probability that there is something wrong with these signals.

It seems the chip uses extra 12k resistors for SATA (p965t-a calls the
pins SJ_REXT[12]), pin 44 for port#1 and 55 for port#2. Both look sane.
I will check the suspected connections with the machine powered off
later.

The RX and TX trace pairs go next to each other for up to 10 mm, could
that be a problem at these frequencies? If so it would show up on
all/many such boards certainly? Can't find any report.

OTOH other people have similar problems with other boards: e.g.
ASUS P5KC: http://ubuntuforums.org/showthread.php?t=766217
           https://bugs.launchpad.net/ubuntu/+source/linux/+bug/377633

(unknown boards)
https://archlinux-fr.org/doku.php?id=securisation:logcheck
http://forum.ubuntu-fr.org/viewtopic.php?pid=2739616
http://ubuntu-ky.ubuntuforums.org/showthread.php?p=7243061
The last one claims:
this started after an upgrade to ubuntu 9.04 and is stll here after re-installing
ubuntu 8.10.
this was fixed by re-installing ubuntu 8.10 only using the kernal,
2.6.27-7-generic.
I don't know if JMB36x is involved in this case, and how reliable the
info is.

Investigating as time permits.
-- 
Krzysztof Halasa

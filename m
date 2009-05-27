Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbZE0C4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbZE0C4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 22:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbZE0C4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 22:56:23 -0400
Received: from relais.videotron.ca ([24.201.245.36]:55340 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbZE0C4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 22:56:22 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8; format=flowed
Message-id: <4A1CABD8.9010802@gmail.com>
Date: Tue, 26 May 2009 22:56:24 -0400
From: Marc Dionne <marc.c.dionne@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre)
 Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
To: linux-kernel@vger.kernel.org
Cc: yu.zhao@intel.com
Subject: JMicron SATA controller not available - bisected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With current git the SATA DVD writer on my system is no longer detected, 
and these errors show up:

pci 0000:05:00.0: BAR 2: can't allocate resource
pci 0000:05:00.0: BAR 3: can't allocate resource
ahci 0000:05:00.0: device not available because of BAR 2 [0x00-0x07] 
collisions

.. where 05:00.0 is this SATA controller where the DVD is plugged in:

05:00.0 SATA controller: JMicron Technologies, Inc. 20360/20363 Serial 
ATA Controller (rev 03)

This is an ICH10-based board that has the JMicron controller in addition 
to the onboard SATA.  The drive works fine if plugged into one of the 
onboard ports, and also works fine with kernel 2.6.29 on the JMicron 
controller.

I bisected the problem down to this commit:
480b93b7837fb3cf0579a42f4953ac463a5b9e1e: PCI: centralize device setup code

Note that this worked with recent 2.6.30-rc kernels until I had to reset 
the board's CMOS, so a change in a BIOS setting was probably a trigger.

Marc


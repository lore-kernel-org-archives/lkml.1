Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbYLOS13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbYLOS13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 13:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbYLOS1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 13:27:07 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:8455 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbYLOS1F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 13:27:05 -0500
From: "Chen, Justin" <justin.chen@hp.com>
To: "Chiang, Alexander" <achiang@hp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: "matthew@wil.cx" <matthew@wil.cx>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 15 Dec 2008 18:26:03 +0000
Subject: RE: PCI BAR mem resource allocation "regression"
Thread-Topic: PCI BAR mem resource allocation "regression"
Thread-Index: AcldiBIvrPJaSDwaTJmS3YaE44GTEgBWKzBA
Message-ID: <B57D568CB82B0C4B897F9CD9862DE8B733BD4294D0@GVW1097EXB.americas.hpqcorp.net>
References: <20081213000538.GC9947@ldl.fc.hp.com>
 <alpine.LFD.2.00.0812130901370.3340@localhost.localdomain>
 <20081214010534.GB22302@ldl.fc.hp.com>
In-Reply-To: <20081214010534.GB22302@ldl.fc.hp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Chiang, Alexander
>
>> Also, is it just the error message, or does it actually affect
>> functionality?
>
>Hm, that is a good question. ;) The particular device I was
>testing with was an infiniband device, and I have never actually
>pushed any traffic over it; just used it to reproduce the error.
>
>I can try and hook the card up to something and push traffic over
>it, but that will have to wait until Monday. Maybe Justin (cc'ed)
>knows, since he was the one who first reported this to me.

It affects functionality.  The BAR is not reprogrammed after hotplug.  Below is an example:

Original lspci dump:
------------------------------
002b:01:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
        Subsystem: Hewlett-Packard Company: Unknown device 704f
        Flags: bus master, fast devsel, latency 0, IRQ 61
        Memory at 00000f7200000000 (32-bit, non-prefetchable) [size=128K]
        Memory at 00000f7200020000 (32-bit, non-prefetchable) [size=128K]
        I/O ports at e000 [size=32]
        Expansion ROM at 00000f7200040000 [disabled] [size=128K]
        Capabilities: [c8] Power Management version 2
        Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
        Capabilities: [e0] #10 [0001]

Mainline lspci after remove/hotplug the device:
------------------------------------------------------------------
002b:01:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
        Subsystem: Hewlett-Packard Company: Unknown device 704f
        Flags: fast devsel, IRQ 61
        I/O ports at <unassigned> [disabled]
        Capabilities: [c8] Power Management version 2
        Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
        Capabilities: [e0] #10 [0001]


Revert lspci after remove/hotplug the device:
---------------------------------------------------------------
002b:01:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
        Subsystem: Hewlett-Packard Company: Unknown device 704f
        Flags: bus master, fast devsel, latency 0, IRQ 61
        Memory at 00000f7200000000 (32-bit, non-prefetchable) [size=128K]
        Memory at 00000f7200020000 (32-bit, non-prefetchable) [size=128K]
        I/O ports at e000 [size=32]
        Expansion ROM at 00000f7200040000 [disabled] [size=128K]
        Capabilities: [c8] Power Management version 2
        Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
        Capabilities: [e0] #10 [0001]

Thanks,
Justin

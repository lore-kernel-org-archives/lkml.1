Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbXEBFUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbXEBFUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbXEBFUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:20:50 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:4591 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbXEBFUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:20:49 -0400
From: James Cloos <cloos@jhcloos.com>
To: linux-kernel@vger.kernel.org
Subject: keyboard and mouse regresions as of dc87c398 plus cfs-v7
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/23.0.0 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAMnRFWHRUaXRsZQAvbWF4dG9y
 L2Nsb29zL2luY29taW5nLzIwMDQvMDIvUFdHL0pIQzE2LnBuZyJMlEwAAAAadEVYdFNvZnR3YXJl
 AEdOT01FIEljb24gRWRpdG9ynioKbAAAAHFJREFUeJzFk8EKwCAMQ1/ED9cvzw6iuM0N9WIvDTWE
 1KjAxmKnLBEBjLcEIBCeI2nccy5YKrjxwbbvAvZ37zlo4GB9iRMC/cq/AppItwmMyJ5I98wd9G7P
 xxgrSKlYS2lMrOcV13o95aVSKA7E5ndGXG+IIzcl4BNfAAAAAElFTkSuQmCC
Copyright: Copyright 2007 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
X-Hashcash: 1:23:070502:linux-kernel@vger.kernel.org::hV1bReFopGpuJ1eY:000000000000000000000000000000000HXuH
Date: Wed, 02 May 2007 01:20:13 -0400
Message-ID: <m34pmv244b.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just tried out git as of commit dc87c398 plus Ingo's cfs v6 patch.

I'll try out w/o the patch to confirm later this morning.

The kernel log shows no indication of a problem, but the (ps/2) mice do
not work, and the keyboard repeat is *very* slow, and will not speed up
if changed with xset(1x).

>From dmesg(1):

[   25.448092] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[   25.460470] serio: i8042 KBD port at 0x60,0x64 irq 1
[   25.466816] serio: i8042 AUX port at 0x60,0x64 irq 12
[   25.473262] mice: PS/2 mouse device common for all mice
[   25.484605] input: AT Translated Set 2 keyboard as /class/input/input3
[   25.497339] input: PC Speaker as /class/input/input4

but no /class/input entry gets generated for the mice.

/proc/interupts shows 5 ints for irq 12, and that does not increment no
matter what is done to the trackpoint, syn pad or external ps/2 mouse.

My last known good version was 0f851021c0f91e5073fa89f26b5ac68e23df8e11
plus the rt patch.

To get dc87c398 plus cfs-v7 I cloned, checked out v2.6.21, applied the
cfs-v7 patch and then pulled in master.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6

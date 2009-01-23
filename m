Return-Path: <linux-kernel-owner+w=401wt.eu-S1758402AbZAWRmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbZAWRmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 12:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbZAWRmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 12:42:03 -0500
Received: from marvin.heresymail.org ([87.106.62.5]:44367 "EHLO
	marvin.heresymail.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbZAWRmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 12:42:01 -0500
Message-ID: <497A0164.90409@walrond.org>
Date: Fri, 23 Jan 2009 17:41:56 +0000
From: Andrew Walrond <andrew@walrond.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: serial8250 madness
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is anyone active in the serial code?

I thought I would make some in-house servers send output via ttyS0 from 
grub, kernel boot and console, like our rented remote servers do. I set 
it all up and basically nothing worked properly, so I started 
investigating with a null modem cable, setserial and cu to see what was 
happening.

Machine A

ttyS0 works fine. Can get grub output, kernel boot and console via ttyS0 
as I wanted.
ttyS1 doesn't work at all. It's detected, enabled in the bios etc etc 
but just doesn't work at all.

Machine B

ttyS0 and ttyS1 will both receive, but neither will send. Go figure. 
Tested using a null modem cable, setserial and cu against the known good 
machine above.

Machine C

Grub and kernel outputs fine during boot, right up til the serial8250 
output appears in the kernel log, at which point it then prints 'LSR 
safety check engaged' and reboots.
Tried again without the console=ttyS0,57600 kernel parameter and it 
boots OK but starts printing the 'LSR...' message again as soon as 
agetty tries to attach to ttyS0. Doesn't reboot though...

The Machines are all amd64, various motherboards, identical distros 
using 2.6.28.1 kernel.
Either I have a particularly motley collection of kit, or the serial 
code is in a pretty bad way.

I can provide further info/testing if anyone is active/interested.

Andrew Walrond


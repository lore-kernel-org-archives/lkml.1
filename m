Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbXGBNSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbXGBNSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 09:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbXGBNSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 09:18:16 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:54192 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566AbXGBNSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 09:18:16 -0400
Message-ID: <4688FB14.90307@free.fr>
Date: Mon, 02 Jul 2007 15:18:12 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [CONFIG_PREEMPT_RT] High frequency periodic timer
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I have been experimenting with the CONFIG_PREEMPT_RT patch for a few 
months. Specifically kernel 2.6.20.7-rt8.

http://rt.wiki.kernel.org/index.php/Main_Page

I've been running into some unexpected problems, so I wanted to ask 
those who have some experience with this patch what they thought.

Here's a brief description of my application:

System A periodically sends timestamped packets. These packets travel 
over a network, or through a network emulator, and get randomly dropped 
or delayed by a random amount of time. These packets reach system B at 
some point. System B uses the timestamp to re-send the packets smoothly, 
as if they had been produced on B, with only a constant time-shift. 
Basically, B acts as a "dejittering" router.

I have implemented this with high-resolution timers. Every time the 
timer fires, I send one packet. In "parallel", I buffer incoming packets 
that arrive from system A.

Consider 1316-byte packets and a 80 Mbit/s stream bit rate.

This means the timer period is 1316*8 / 80 = 131.6 µs

I've been wondering whether having such a small period (high frequency) 
might be a problem / challenge for the real-time kernel (scheduler, IRQ 
handler, other component).

The CPU used is mid-range (i.e. 1.5 GHz Celeron M) single core, and it 
easily copes with just the receiving part.

But I have seen some odd behavior (random crashes in my program) that 
must mean I have made some incorrect assumptions.

What do you all think?

Regards.

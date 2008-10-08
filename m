Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbYJHDoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbYJHDoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 23:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYJHDnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 23:43:53 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:26068 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbYJHDnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 23:43:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=w3A6PfIGzqdqeRH0BxJZLV3eK/Se1Xq3PO4U8LZLHQ71dzONHN+fRk2k6J902L5ecA
         nJ7wh3U9x7gDQwrgudhaBuPEC55abZlhPCq0mYY6Kbvcqh69PSiQyE0kOA0oghXPFFnC
         P0YdwsFFR0/zYTff7Vdo1fQQpqEQI2NV9fUe8=
Message-ID: <9e4733910810072043m6c69f3bdv104bd32928fe64ae@mail.gmail.com>
Date: Tue, 7 Oct 2008 23:43:50 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Toggling GPIO at 38Khz
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working on getring the LIRC IR subsystem integrated into the
kernel. One common IR hardware implementation is based on standard
serial ports. It uses the serial port's DCD and DTR as GPIO pins.
This common IR hardware does not have a transmit modulator and is
modulating the IR signal in software. Luckily is has hardware
demodulation.

There are four common IR frequencies - 36Khz, 38Khz, 40Khz, 56Khz. I
need to create these frequencies in software. Data is then transmitted
as 400-600us burst of these frequencies. Around 10-30 clock pulses.

So how do I reliably generate 38Khz without destroying latency in the
system? I also don't want to measure the speed of the code I'm
executing - same code has to run on 90Mhz ARM and 3Ghz Core2. If a do
a loop with nanosleep() I need to know how fast my code is to subtract
it's execution time form the sleep time. The existing LIRC code works
this way and measures it's timing loop.

hrtimers look promising, but hrtimers doesn't have a periodic API. Is
there a technique for creating periodic timing that doesn't accumulate
error caused by rescheduling the timers?  If I need to send 30 pulses
of 38Khz, it is more important that the total time be (1/38000)*30 =
0.7894ms than it is for each pulse to be generated at exactly 26.3us
intervals.

Are there other techniques for generating pulse trains in the 36-56Khz
range on a simple GPIO pin? Anyone have some sample code?

-- 
Jon Smirl
jonsmirl@gmail.com

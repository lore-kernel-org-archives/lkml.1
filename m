Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbYDRK1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbYDRK1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 06:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbYDRK10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 06:27:26 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:54917 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbYDRK1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 06:27:25 -0400
Message-ID: <480874E8.7040903@aitel.hist.no>
Date: Fri, 18 Apr 2008 12:16:08 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Problem with delayed data from pl2303 usb serial gps
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem:
I run car navigation software on linux, using a gps.
Getting data from the gps unit in a timely fashion is important, as
the software says thing like "turn left in 50m". That is useless however,
if the message arrives 10s after you passed the intersection!

The gps unit reports location once per second.
I frequently see delays of up to 13 seconds. I drive down a street and
make a turn or stop. Then I look at map display, and count 13 updates
before the map reflects what I did.

This is also a problem when mapping in real-time. I.e. someone drive the car
over a bridge, and I record the bridge start and endpoints on the live 
gps tracklog.
Needless to say, this approach doesn't work if the live tracklog lags behind
reality by 13s. . .

I make sure the pc has a load well below 1, so this is not cpu 
starvation. This even
happens with dual cores. I have observed the problem with two different
machines: a core2duo laptop in 64bit mode, and a via mini-itx in 32-bit 
mode.

I have also seen the problem with various software, a commercial navigation
program reading directly from /dev/ttyUSB0, as well as the open programs
josm and navit, both going via gpsd. gpsd is supposed to run with low 
latency.

The problem is an old one. It is in 2.6.24, and it existed a couple of years
ago too. I have used two different gps units (my old one broke) of
different manufacture. Both uses pl2303 though.

The delay is not constant. Everything may be ok when I start the
software, and then the delay build up gradually over a few minutes.

Is there hope of fixing this, or is the pl2303 something to avoid?

Helge Hafting

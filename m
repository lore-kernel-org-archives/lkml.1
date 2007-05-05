Return-Path: <linux-kernel-owner+w=401wt.eu-S1423408AbXEEQAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423408AbXEEQAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423347AbXEEQAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:00:14 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:52379
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423344AbXEEQAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:00:11 -0400
Message-ID: <463CB429.6050201@microgate.com>
Date: Sat, 05 May 2007 10:43:21 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Antonino Ingargiola <tritemio@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible
 bug]
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>	 <1178299247.3769.0.camel@amdx2.microgate.com>	 <5486cca80705041025k46ccf716t8dcd1e6f29e2376e@mail.gmail.com>	 <1178300493.3619.1.camel@amdx2.microgate.com>	 <5486cca80705041146x5c5bda70s96ce74e389cc1635@mail.gmail.com>	 <5486cca80705041206q3a077dedyedb5ac2fbf434ba8@mail.gmail.com>	 <1178308173.3743.14.camel@amdx2.microgate.com>	 <5486cca80705041421y4fcaec01l7acafed1cea4b509@mail.gmail.com>	 <463BC223.2040304@microgate.com> <1178353618.3472.1.camel@x2> <5486cca80705050811k2903710y2bf9054434d8da4b@mail.gmail.com>
In-Reply-To: <5486cca80705050811k2903710y2bf9054434d8da4b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antonino Ingargiola wrote:
> The patch now boot properly and solves
> completely the testcase with two serial lines:

Good, thanks for testing.

> I think this patch should be included in mainline, since if one flushes
> the input buffer, really want to flush the entire buffer chain and
> doesn't want to read any old data _after_ a flush.

I will submit the patch, it's clearly needed.

> However I also tested a usb-serial device (that uses the cdc-acm
> driver) and in this case I still need _two_ flushInput() to totally
> flush the input buffer.
> 
> There can be another *secondary buffer* in the usb-serial driver? Can
> this buffer be emptied out too?

Very possible, but I'm not familiar with that.

There is not an input flush method for the tty driver
and individual drivers don't process that ioctl.
The tty drivers I've seen immediately pass receive data to the
tty buffering and I'm not sure why a driver would
behave otherwise.

--
Paul

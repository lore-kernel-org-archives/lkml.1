Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbXEEQKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbXEEQKW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbXEEQJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:09:55 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:36326
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224AbXEEQJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:09:49 -0400
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial
	possible bug]
From: Paul Fulghum <paulkf@microgate.com>
To: Antonino Ingargiola <tritemio@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <463CB429.6050201@microgate.com>
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <1178299247.3769.0.camel@amdx2.microgate.com>
	 <5486cca80705041025k46ccf716t8dcd1e6f29e2376e@mail.gmail.com>
	 <1178300493.3619.1.camel@amdx2.microgate.com>
	 <5486cca80705041146x5c5bda70s96ce74e389cc1635@mail.gmail.com>
	 <5486cca80705041206q3a077dedyedb5ac2fbf434ba8@mail.gmail.com>
	 <1178308173.3743.14.camel@amdx2.microgate.com>
	 <5486cca80705041421y4fcaec01l7acafed1cea4b509@mail.gmail.com>
	 <463BC223.2040304@microgate.com> <1178353618.3472.1.camel@x2>
	 <5486cca80705050811k2903710y2bf9054434d8da4b@mail.gmail.com>
	 <463CB429.6050201@microgate.com>
Content-Type: text/plain
Date: Sat, 05 May 2007 11:08:07 -0500
Message-Id: <1178381287.3379.8.camel@x2>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-05 at 10:43 -0600, Paul Fulghum wrote:
> There is not an input flush method for the tty driver
> and individual drivers don't process that ioctl.
> The tty drivers I've seen immediately pass receive data to the
> tty buffering and I'm not sure why a driver would
> behave otherwise.

cdc-acm does its own buffering.

In your case, the line discipline throttled the tty device
because the ldisc buffer was full.

If the line discipline throttles the driver input,
the cdc-acm driver stops giving data to the tty buffering
and instead stores them internally.

In the serial driver this usually just results in dropping
RTS to signal the remote end to stop sending. The serial
driver always immediately gives receive data to the tty buffering
without regard to the throttled state.

I would argue that cdc-acm should do the same as the serial driver.

--
Paul



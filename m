Return-Path: <linux-kernel-owner+w=401wt.eu-S936871AbYD1Qyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936871AbYD1Qyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934917AbYD1Qy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:54:28 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:17345 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934764AbYD1Qy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:54:28 -0400
Date: Mon, 28 Apr 2008 18:53:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org
Subject: Re: i2c or eeprom enumeration problem
Message-ID: <20080428185337.0f15e94b@hyperion.delvare>
In-Reply-To: <4815ECD0.80201@redhat.com>
References: <4815509A.9040802@redhat.com>
	<20080428050515.fcc05689.akpm@linux-foundation.org>
	<20080428141526.2f4e993f@hyperion.delvare>
	<4815DC52.1050908@redhat.com>
	<20080428162123.7fd8eb04@hyperion.delvare>
	<4815ECD0.80201@redhat.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulrich,

On Mon, 28 Apr 2008 08:27:12 -0700, Ulrich Drepper wrote:
> Jean Delvare wrote:
> > OK. Maybe it uses the same trick as the S4882... Can you get the
> > information from Tyan?
> 
> I don't have a special link to Tyan but I can try.  What information do
> you need?

Basically, whether the SMBus is multiplexed or not, and if it is, what
is the SMBus topology (which mux chip is used and how to control it,
how many segments, what devices are connected to each segment.)

> > Please provide the output of i2cdetect for all the SMBus channels.
> 
> [Strange, the lm_sensors package in F9 doesn't have i2cdetect anymore.
> Anything replacing it?]

Yes, the i2c tools (i2cdetect, i2cdump, the eeprom decoding scripts,
etc.) now live in their separate package named i2c-tools:
http://www.lm-sensors.org/wiki/I2CTools
As far as I know, Hans de Goede packaged it in Fedora already.

[Note that the lm-sensors.org website is exceptionally slow today.]

> 
> I see two busses:
> 
>   Installed I2C busses:
>     i2c-0       smbus           SMBus nForce2 adapter at a000
>     i2c-1       smbus           SMBus nForce2 adapter at a040
> 
> Using -a to get all the info on those busses I see this:

-a wasn't needed...

> 
> Bus 0:
> 
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> 00: -- -- -- -- -- -- -- -- 08 -- -- -- -- -- -- --
> 10: -- -- -- -- -- -- -- -- 18 -- -- -- -- -- -- --
> 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 50: UU UU UU UU -- -- -- -- -- -- -- -- -- -- -- --
> 60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 70: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 

SPD for 4 memory modules at 0x50 - 0x53. 0x18 could be a multiplexer,
that's the address that was used by the 8-channel multiplexer on the
S4882.

> 
> Bus 1:
> 
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> 00: -- -- -- -- -- -- -- -- 08 -- -- -- -- -- -- --
> 10: -- -- -- -- -- -- -- -- -- 19 -- -- -- -- -- --
> 20: -- -- -- -- -- -- -- -- -- -- -- -- -- 2d -- --
> 30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 40: -- -- -- -- -- -- -- -- 48 49 -- -- -- -- -- --
> 50: -- UU -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 70: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

Apparently you have some Winbond hardware monitoring chip at 0x2d +
0x48 + 0x49. You might try sensors-detect.

There seems to be an extra EEPROM at 0x51, I'm curious what it is...
Presumably not an SPD.

No idea what is at 0x19, it could be a multiplexer but I'd be
surprised, as it doesn't make much sense to multiplex both SMBus
channels.

> This motherboard uses the NVidia nForce n4250QE chipset.

We won't be able to re-use the S4882 code as is, as that one was using a
completely different chip (AMD).

If you are willing to do some experiments with the board, I can give
you commands to test (you'll need i2cdetect and i2cset). But maybe
you'll prefer to wait to have additional information from Tyan first.
Let me know.

-- 
Jean Delvare

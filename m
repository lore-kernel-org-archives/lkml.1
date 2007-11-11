Return-Path: <linux-kernel-owner+w=401wt.eu-S1756319AbXKKAC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbXKKAC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 19:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755757AbXKKACU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 19:02:20 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:64875 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556AbXKKACT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 19:02:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ZHki0/MqvZHMa6NP/Skd3EYDwfOAXO41dPLq9RxP36uWwxtVpVKGHNaS5S5dUXjRMeurcLXBqQo2LizToC1ffE+FdwnIpT21ctL0QFGbchFRF9LXhcRZQma4q/LWc5WdjnSFI9ia77ohztYcWkNiloPmpOEXuqBlmSDOYySxZmA=
Message-ID: <d7b238da0711101602y61f8b5b9j4248c690cc79bb8d@mail.gmail.com>
Date: Sun, 11 Nov 2007 08:02:19 +0800
From: "dave chung" <ponstrip@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: problems with spi interface & ads 784X under 2.6.23
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

on kernel 2.6.23 , with an  Arm AT91rm9200
sometimes when i  "pen-down" on the touch screen,I'm seeing

ads7846 spi0.0: touchscreen, irq 75
input: ADS784x Touchscreen as /devices/platform/atmel_spi.0/spi0.0/input/input0
at91_rtc at91_rtc: rtc core: registered at91_rtc as rtc0



atmel_spi atmel_spi.0: fifo overrun (0/1 remaining)
atmel_spi atmel_spi.0: timeout waiting for TXEMPTY<7>ads7846 spi0.0:
DEactivate 35, mr 000f0011
atmel_spi atmel_spi.0: fifo overrun (0/1 remaining)
atmel_spi atmel_spi.0: timeout waiting for TXEMPTY<7>ads7846 spi0.0:
DEactivate 35, mr 000f0011



it appears to be coming from /drivers/touchscreen/ads7846.c

also even stranger, a cat of  the TS when the pen is down produces:
# cat /dev/ts |hexdump
returns
0000000 ea9c 34aa 0d64 0007 0001 014a 0001 0000
0000010 ea9c 34aa 0dde 0007 0003 0018 1d4c 0000
0000020 ea9c 34aa 0e1b 0007 0000 0000 0000 0000
0000030 ea9c 34aa 8c84 0008 0001 014a 0000 0000
0000040 ea9c 34aa 8cdf 0008 0003 0018 0000 0000
0000050 ea9c 34aa 8d1c 0008 0000 0000 0000 0000
0000060 ea9d 34aa c9af 0004 0001 014a 0001 0000
0000070 ea9d 34aa ca29 0004 0003 0018 1d4c 0000
0000080 ea9d 34aa ca66 0004 0000 0000 0000 0000

when the pen is down , notice that the left column is a sequence of
incrementing words, at "second" intervals , the value of which change
when i turn off the "RTC" compillation in the kernel, but this may be
down to the interrupts.
After consulting the curcuit diagrams , the only "odd" thing i can see
is that the "penirq" is tied to pin  PB11, but it is obviously working
as i only get output when the pen is down

under kernel 2.6.13 the touchscreen actually works fine.
and a cat of it's output is more reasonable.

000000 0001 0c39 07e0 be98 0001 0c33 0801 be98
0000010 0001 0c35 07e2 be98 0001 0c41 07d4 be98
0000020 0001 0c40 07d0 be98 0001 0c08 0859 be98
0000030 0001 0c4c 07d1 be98 0001 0c5a 070f be98
0000040 0001 0c3f 074a be98 0001 0bf3 07e5 be98
0000050 0001 0c40 07e4 be98 0001 0c40 07f5 be98
0000060 0001 0c63 07e3 be98 0001 0c3c 07d2 be98
0000070 0001 0c44 07ce be98 0001 0c3e 07d2 be98
0000080 0001 0c40 07cf be98 0001 0c56 071f be98

which does actually seem to be representative of reasonalbe screen positions

Dave

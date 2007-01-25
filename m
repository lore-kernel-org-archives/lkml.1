Return-Path: <linux-kernel-owner+w=401wt.eu-S1030465AbXAYXGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030465AbXAYXGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 18:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030481AbXAYXGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 18:06:21 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:11138 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030465AbXAYXGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 18:06:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=nGB+8khoFj2b0uJEvJin0167sI3nQ/tNn/g2OgQeYXcP9MLcAho2+nozSGMy9cPoFdyjMPha4OBTdFLFM3s3ZReOsFIvgvjXz4ZjFtn8YOFZVt9ure/WkXnvFLQWJiUfWl0NQjuzhHHcZXl8186E3MLWrZcYKW86REdvo9UFZFE=
Message-ID: <a37929f0701251506i2778aed2v80e8742dcb3ad10e@mail.gmail.com>
Date: Fri, 26 Jan 2007 00:06:20 +0100
From: "mirek kratochvil" <exa.exa@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Problems on x86_64 laptops (high-load crashes?)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I want to ask about strange behavior of linux kernel
on some laptops (namely recent Asus laptops with
dualcore 64bit Athlons). There's a weird bug when
the kernel's under some kind of heavy load. It usually
freezes all processes which run from X11 (including
X11..) - happens usually when:

1] starting some kind of OpenGL (not very often..)
2] transmitting heavy traffic to ethernet (Almost
   everytime - all you need to do is make it send
   data faster then 1MB/s and wait 10 secs)
3] randomly (yeah it's rare, but happens..)

If running X, the system becomes absolutely
unusuable - all it does is that it catches acpi events
a few more seconds before a complete freeze.

I tried to debug - switch to console and reproduce
the bug with network load -- result is that it doesn't
freeze when in console, but it usually leaves network
interface unusuable (doesn't send/receive, but
statistics (/proc/dev/net) show some tx bytes (not more
than 300B) ). It needs a reboot to work again.

Worst thing is that I could't get any kind of debugging info.
Last thing I got were some watchdog messages (about
tx transmit timeouts), turning off watchdog doesn't help
(it just removes that "crash info"). I'm not getting anything
more in dmesg, no oopses, no panic. I have no idea how
to get more info.

I guess it could be about bad driver for eth - I'm using
r8169 for realtek8168 PCI-E gigabit. afaik Realtek's
r1000 driver makes this problem too.

about versions - I tried all kernels from 2.6.17  to
2.6.20-rc5, all affected. PREEMPT doesn't do any
difference. Turning off SMP also doesn't help.
If anyone wanted exact configurations which I
tested please ask me.

about hardware - this is mostly seen on Asus A6
and similar laptops. A6T, A6Tc, A6Km,....

so please - Is there some better way to debug this?
If I was able to do so, I'd happilly post fixes, but I have
no idea how to get some more info. honestly I'm not
even sure that it's the bug of r8169, as I read some
similar crash reports about disc activity and so...

If anyone encountered this kind of problems before,
please help me id and solve it.

thanks
M. Kratochvil

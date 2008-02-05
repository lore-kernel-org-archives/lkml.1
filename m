Return-Path: <linux-kernel-owner+w=401wt.eu-S1760802AbYBEVHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802AbYBEVHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758563AbYBEVHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:07:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41155 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044AbYBEVHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:07:36 -0500
Message-ID: <47A8D00F.9040803@zytor.com>
Date: Tue, 05 Feb 2008 13:07:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24 says "serial8250: too much work for irq4" a lot.
References: <200802051455.10831.rob@landley.net>
In-Reply-To: <200802051455.10831.rob@landley.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> When running a 2.6.24 kernel built for x86-64 under qemu via serial console, 
> doing CPU-intensive things that also produce a lot of output (such as 
> compiling software) tends to produce the error message in the title.
> 
> Anybody have a clue why?  It doesn't seem to cause an actual problem, but it's 
> kind of annoying.
> 
> (If it's a qemu issue, I can go bother them.  It's possible that qemu isn't 
> delivering interrupts as often as it expects, since that's limited by the 
> granularity of the host timer; I know the clock in qemu can run a bit slow 
> because it only gets clock interrupts when the host system isn't too busy to 
> schedule the emulator.  But this doesn't usually cause a problem.  I _think_ 
> the message is just a "this should never happen" type warning, which is 
> happening to me.  But I break stuff. :)

This is because Qemu spews data to the serial port without any rate 
limiting; this causes the in-kernel serial port driver to think the port 
is stuck.  The serial port emulation needs to make it possible to drain 
the virtual FIFO every now and then, as opposed to filling it again 
immediately.

	-hpa

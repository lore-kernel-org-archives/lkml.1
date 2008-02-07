Return-Path: <linux-kernel-owner+w=401wt.eu-S1757615AbYBGRhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615AbYBGRhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 12:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756494AbYBGRhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 12:37:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41804 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227AbYBGRhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 12:37:34 -0500
Message-ID: <47AB41C8.3010001@zytor.com>
Date: Thu, 07 Feb 2008 09:37:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24 says "serial8250: too much work for irq4" a lot.
References: <200802051455.10831.rob@landley.net> <47A8D00F.9040803@zytor.com> <20080207123937.GC15647@elte.hu>
In-Reply-To: <20080207123937.GC15647@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>>> (If it's a qemu issue, I can go bother them.  It's possible that qemu 
>>> isn't delivering interrupts as often as it expects, since that's 
>>> limited by the granularity of the host timer; I know the clock in 
>>> qemu can run a bit slow because it only gets clock interrupts when 
>>> the host system isn't too busy to schedule the emulator.  But this 
>>> doesn't usually cause a problem.  I _think_ the message is just a 
>>> "this should never happen" type warning, which is happening to me.  
>>> But I break stuff. :)
>> This is because Qemu spews data to the serial port without any rate 
>> limiting; this causes the in-kernel serial port driver to think the 
>> port is stuck.  The serial port emulation needs to make it possible to 
>> drain the virtual FIFO every now and then, as opposed to filling it 
>> again immediately.
> 
> actually, the way i solved it for qemu+KVM+paravirt was to just turn off 
> this rather silly check in the serial driver if inside a paravirt guest. 
> When we are emulated then the serial 'hardware' is totally reliable and 
> we should just trust it. That way i never dropped a single bit of kernel 
> log output again.
> 

Yes, but keying that on paravirt is silly in the extreme.  After all, 
there is no need for this to be paravirtualized.

	-hpa

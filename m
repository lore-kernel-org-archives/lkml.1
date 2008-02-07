Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbYBGMkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbYBGMkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759203AbYBGMj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:39:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59074 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758223AbYBGMjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:39:53 -0500
Date: Thu, 7 Feb 2008 13:39:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24 says "serial8250: too much work for irq4" a lot.
Message-ID: <20080207123937.GC15647@elte.hu>
References: <200802051455.10831.rob@landley.net> <47A8D00F.9040803@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A8D00F.9040803@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

>> (If it's a qemu issue, I can go bother them.  It's possible that qemu 
>> isn't delivering interrupts as often as it expects, since that's 
>> limited by the granularity of the host timer; I know the clock in 
>> qemu can run a bit slow because it only gets clock interrupts when 
>> the host system isn't too busy to schedule the emulator.  But this 
>> doesn't usually cause a problem.  I _think_ the message is just a 
>> "this should never happen" type warning, which is happening to me.  
>> But I break stuff. :)
>
> This is because Qemu spews data to the serial port without any rate 
> limiting; this causes the in-kernel serial port driver to think the 
> port is stuck.  The serial port emulation needs to make it possible to 
> drain the virtual FIFO every now and then, as opposed to filling it 
> again immediately.

actually, the way i solved it for qemu+KVM+paravirt was to just turn off 
this rather silly check in the serial driver if inside a paravirt guest. 
When we are emulated then the serial 'hardware' is totally reliable and 
we should just trust it. That way i never dropped a single bit of kernel 
log output again.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S934360AbXC2X3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934360AbXC2X3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 19:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934377AbXC2X3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 19:29:41 -0400
Received: from hu-out-0506.google.com ([72.14.214.225]:42756 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934375AbXC2X3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 19:29:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=hgHsULEe0hPexk7EvZCzv9vPnCGe3bHueBkwvw9YUnArWO2IleB3evETPahXwjSpWenntR4t46ZZiag1YwyhBHysjR+2xCv9VXOADR84Ujx8f1vowoCT+aLt0mD4ReDlj7Z0z6yfqhNw9xZhUPMHME3wImB4rFB3USsJEobURWM=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] [3/6] 2.6.21-rc4: known regressions
Date: Fri, 30 Mar 2007 01:29:27 +0200
User-Agent: KMail/1.9.6
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, gregkh@suse.de,
       Ingo Molnar <mingo@elte.hu>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, jgarzik@pobox.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-pm@lists.linux-foundation.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703282327.56132.maximlevitsky@gmail.com> <200703291533.38002.david-b@pacbell.net>
In-Reply-To: <200703291533.38002.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703300129.27474.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 March 2007 00:33:35 David Brownell wrote:
> On Wednesday 28 March 2007 2:27 pm, Maxim wrote:
> > On Wednesday 28 March 2007 22:59:26 David Brownell wrote:
> 
> > 	When HPET is active it eats RTC IRQ,
> 
> Only when HPET timers 0 and 1 are set up for "Legacy Replacement Mode".
> In the more sensible "Standard Mode", they have their own IRQs.
> 
> 
> > 	So the only way out is to emulate RTC using HPET,
> > 	It is done this way in old rtc driver, rtc-cmos should do the same.
> 
> No.  Patches like
> 
>   http://marc.info/?l=linux-kernel&m=117219531503973&w=2
> 
> should be merged (I hope they're in the 2.6.22 queue!), making
> HPET run in "Standard Mode" so that HPET can stop sticking its
> fingers in code where they don't belong.
> 
> 
> > 	I am also planning to add support of HPET and suspend/resume
> > 	for rtc-cmos, but I didn't start this yet. 
> 
> It's already got suspend/resume support, and in the 2.6.22 queue
> are RTC framework updates which will let the RTC framework replace
> a lot more platform-specific RTC support.  (Platform changes can come
> later, where they're needed.  ARM for example doesn't need any.)
> 
> Once HPET stops using "Legacy Replacement Mode" you won't need to
> touch anything in the RTC stack (except maybe the legacy char/rtc.c
> driver, removing HPET stuff).
> 
> The open issue with suspend/resume support in rtc-cmos relates to
> how ACPI wakeup alarms should trigger.  I've not made time to test
> those patches.
> 
> - Dave
> 

Hi,
	It is not that simple,

	Only in legacy replacement mode HPET can be put on IRQ0 (and sadly  IRQ8)
	At least this is true on some systems, on mine for example
	
	On my system first 2 hpet timers can only be assigned to IRQ21-23
	and third to ether IRQ11, IRQ21-IRQ23

	Or in legacy replacement mode first is assigned IRQ0 and second IRQ8

	this will make it difficult to use it as a clockevents source

	Not to mention the fact that current code assumes that BIOS assigned IRQs to all timers which is not true on my system.

	I have brand new intel DG965 motherboard.

	What is wrong with relying on HPET to provide RTC IRQ ?

	Best regards,
		Maxim Levitsky


Return-Path: <linux-kernel-owner+w=401wt.eu-S1422668AbXC2Wdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422668AbXC2Wdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 18:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422682AbXC2Wdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 18:33:42 -0400
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:41902 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1422669AbXC2Wdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 18:33:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hTgt+IsrfuK+vyQFTqkaFjfiSGg1L5sPmggAO1CkTbUO8ihfuLDUCU1Nh8YPAoBlHDvoHUNu/+SPliHDG5f9idmQvlkS8TPABg7bD1OuIdPIV8P0rMvlWUmALz9GKe+u6gYPn67qfsx/y59Z7rvaZS626/yKxebHoquU4vDV/I0=  ;
X-YMail-OSG: KMUMTiAVM1mwB6w.P8OIssKBCCH3KMcBa359YVYthOZgf8jiv2N65S70f.X7QvVkQFpEpuIuRwl2HqjsFPU0uwmhMz43rstC441r1_3iPWY9jtT96Fg-
From: David Brownell <david-b@pacbell.net>
To: Maxim <maximlevitsky@gmail.com>
Subject: Re: [linux-pm] [3/6] 2.6.21-rc4: known regressions
Date: Thu, 29 Mar 2007 15:33:35 -0700
User-Agent: KMail/1.7.1
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
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703281359.29009.david-b@pacbell.net> <200703282327.56132.maximlevitsky@gmail.com>
In-Reply-To: <200703282327.56132.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703291533.38002.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2007 2:27 pm, Maxim wrote:
> On Wednesday 28 March 2007 22:59:26 David Brownell wrote:

> 	When HPET is active it eats RTC IRQ,

Only when HPET timers 0 and 1 are set up for "Legacy Replacement Mode".
In the more sensible "Standard Mode", they have their own IRQs.


> 	So the only way out is to emulate RTC using HPET,
> 	It is done this way in old rtc driver, rtc-cmos should do the same.

No.  Patches like

  http://marc.info/?l=linux-kernel&m=117219531503973&w=2

should be merged (I hope they're in the 2.6.22 queue!), making
HPET run in "Standard Mode" so that HPET can stop sticking its
fingers in code where they don't belong.


> 	I am also planning to add support of HPET and suspend/resume
> 	for rtc-cmos, but I didn't start this yet. 

It's already got suspend/resume support, and in the 2.6.22 queue
are RTC framework updates which will let the RTC framework replace
a lot more platform-specific RTC support.  (Platform changes can come
later, where they're needed.  ARM for example doesn't need any.)

Once HPET stops using "Legacy Replacement Mode" you won't need to
touch anything in the RTC stack (except maybe the legacy char/rtc.c
driver, removing HPET stuff).

The open issue with suspend/resume support in rtc-cmos relates to
how ACPI wakeup alarms should trigger.  I've not made time to test
those patches.

- Dave

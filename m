Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbXETNk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbXETNk7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 09:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbXETNkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 09:40:52 -0400
Received: from www.osadl.org ([213.239.205.134]:42523 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755994AbXETNkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 09:40:52 -0400
Subject: Re: [SMP BUG]  [clockevents: i386 drivers patch]  introduces 
	irqbalance-does-not-work-properly problem
From: Thomas Gleixner <tglx@linutronix.de>
To: Komuro <komurojun-mbn@nifty.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <20070520194801.6436597c.komurojun-mbn@nifty.com>
References: <1178202559.3767.21.camel@localhost.localdomain>
	 <20070504233238.ca55c2d1.komurojun-mbn@nifty.com>
	 <1178463619.3793.14.camel@localhost.localdomain>
	 <1178777214.2951.18.camel@ymzhang>
	 <20070510160615.6aa9cef6.akpm@linux-foundation.org>
	 <20070513200444.9d2db4c3.komurojun-mbn@nifty.com>
	 <20070520111409.1793a2f6.komurojun-mbn@nifty.com>
	 <1179644956.21827.5.camel@chaos>
	 <20070520194801.6436597c.komurojun-mbn@nifty.com>
Content-Type: text/plain
Date: Sun, 20 May 2007 15:47:04 +0200
Message-Id: <1179668825.21827.18.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-20 at 19:48 +0900, Komuro wrote:
> The problem is CPU1 receives 38239 interrupt-16
> but CPU0 receives only 15 interrupt-16
> CPU0 should receive more interrupts.
> 
>            CPU0       CPU1       
>   0:         85          0   IO-APIC-edge      timer
>   1:          0        698   IO-APIC-edge      i8042
>   6:          0          5   IO-APIC-edge      floppy
>   8:          0          1   IO-APIC-edge      rtc
>   9:          0          0   IO-APIC-fasteoi   acpi
>  12:          0        114   IO-APIC-edge      i8042
>  14:        369       2281   IO-APIC-edge      ide0
>  15:          0         24   IO-APIC-edge      ide1
>  16:         15      38239   IO-APIC-fasteoi   yenta, pcnet_cs   <<< problem
>  17:          0          0   IO-APIC-fasteoi   yenta
> NMI:          0          0 
> LOC:      50548      50547 
> ERR:          0
> MIS:      15503

And how exactly is this related to clock events ?

	tglx



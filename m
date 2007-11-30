Return-Path: <linux-kernel-owner+w=401wt.eu-S1764366AbXK3SqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764366AbXK3SqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 13:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763739AbXK3Spx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 13:45:53 -0500
Received: from iriserv.iradimed.com ([72.242.190.170]:10009 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764039AbXK3Spv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 13:45:51 -0500
Message-ID: <47505A63.8070507@cfl.rr.com>
Date: Fri, 30 Nov 2007 13:45:55 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       noah <noah123@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: Possibly SATA related freeze killed networking and RAID
References: <d00698fb0711201109m23ff096eiabeb22c8f9a917dc@mail.gmail.com> <20071120220512.46b9e975@the-village.bc.nu> <20071126120649.GC4701@ucw.cz> <474CCA82.7030000@gmail.com> <474F3A4B.3080304@cfl.rr.com> <474F530D.8090302@gmail.com>
In-Reply-To: <474F530D.8090302@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Nov 2007 18:46:02.0901 (UTC) FILETIME=[41DF4C50:01C83381]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1023-15578.000
X-TM-AS-Result: No--12.354000-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Because SFF ATA controller don't have IRQ pending bit.  You don't know
> whether IRQ is raised or not.  Plus, accessing the status register which
> clears pending IRQ can be very slow on PATA machines.  It has to go
> through the PCI and ATA bus and come back.  So, unconditionally trying
> to clear IRQ by accessing Status can incur noticeable overhead if the
> IRQ is shared with devices which raise a lot of IRQs.

There HAS to be a way to determine if that device generated the 
interrupt, or the interrupt can not be shared.  Since the kernel said 
nobody cared about the interrupt, that indicates that the sata driver 
checked the status register and realized the sata chip didn't generate 
the interrupt, and returned to the kernel letting it know that the 
interrupt was not for it.


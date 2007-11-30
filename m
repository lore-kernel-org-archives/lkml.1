Return-Path: <linux-kernel-owner+w=401wt.eu-S1764063AbXK3ACr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764063AbXK3ACr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 19:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763582AbXK3ACf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 19:02:35 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:50210 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763578AbXK3ACd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 19:02:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=SmZ1tUuWMrWCObuojCk5YbWk+Qul2ONjKeSLpJ6TxUaSxdaVcWrlTIfTiyrXmUz/80Nm0kaWRGRhovgq/rDPHJrvD7Pb9tNgs0LoH3XMVcusYdSur0vt0XkFZFjy8n6jHNdAyk7+aAxTZIqTfcNJGoJXHCW49Gy5WrQ7xx9J+Xk=
Message-ID: <474F530D.8090302@gmail.com>
Date: Fri, 30 Nov 2007 09:02:21 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Phillip Susi <psusi@cfl.rr.com>
CC: Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       noah <noah123@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: Possibly SATA related freeze killed networking and RAID
References: <d00698fb0711201109m23ff096eiabeb22c8f9a917dc@mail.gmail.com> <20071120220512.46b9e975@the-village.bc.nu> <20071126120649.GC4701@ucw.cz> <474CCA82.7030000@gmail.com> <474F3A4B.3080304@cfl.rr.com>
In-Reply-To: <474F3A4B.3080304@cfl.rr.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> Tejun Heo wrote:
>> Agreed.  Nobody cared on ATA controllers is usually very effective at
>> taking the whole machine down.  Is there any reason why we don't turn on
>> irqpoll on turned off IRQs automatically?
> 
> Why does a single spurious interrupt cause it to be shut down?  I can
> see if the interrupt is stuck on and keeps interrupting constantly, but
> if it's just the occasional spurious interrupt, why not just ignore it
> and move on?

Because SFF ATA controller don't have IRQ pending bit.  You don't know
whether IRQ is raised or not.  Plus, accessing the status register which
clears pending IRQ can be very slow on PATA machines.  It has to go
through the PCI and ATA bus and come back.  So, unconditionally trying
to clear IRQ by accessing Status can incur noticeable overhead if the
IRQ is shared with devices which raise a lot of IRQs.

-- 
tejun

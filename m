Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbYDUBih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbYDUBih (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 21:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYDUBi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 21:38:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51489 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbYDUBi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 21:38:28 -0400
Message-ID: <480BF00D.9090700@garzik.org>
Date: Sun, 20 Apr 2008 21:38:21 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alan Cox <alan@redhat.com>, R.E.Wolff@BitWizard.nl
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/15] drivers/char: minor irq handler cleanups
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com> <e3b010fa8e3bc3a5e386759f01f69c80918923e7.1208559659.git.jgarzik@redhat.com> <20080419161634.GA16424@devserv.devel.redhat.com>
In-Reply-To: <20080419161634.GA16424@devserv.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Fri, Apr 18, 2008 at 07:22:51PM -0400, Jeff Garzik wrote:
>> +++ b/drivers/char/cyclades.c
>>  	if (unlikely(!ISZLOADED(*cinfo))) {
>>  #ifdef CY_DEBUG_INTERRUPTS
>> -		printk(KERN_DEBUG "cyz_interrupt: board not yet loaded "
>> -				"(IRQ%d).\n", irq);
>> +		printk(KERN_DEBUG "cyz_interrupt: board not yet loaded\n");
> 
> If you are debugging IRQ funnies you really really want to know which
> IRQ or which port.
> 
> Ack the rest on the base the __foo_interrupt uglies will go away with the
> final change over. A follow up patch to tweak cyclades would be useful and also
> to know from Andrew if these are going in so they don't clash with the coding
> style cleanups also queued.

In the stuff I pushed just now, I took the attitude "if there was 
remotely a peep from anyone, do not send it"

So the stuff ya'll mentioned shouldn't be in the push at all.

In particular, I wanted to note the __foo_interrupt stuff will not go 
away when I remove the 'irq' arg from all handlers...  we still need to 
indicate two separate callsites (local poll or system irq) to achieve 
the same behavior as exists today.

	Jeff



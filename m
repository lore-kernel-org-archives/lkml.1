Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbXFAW2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbXFAW2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbXFAW2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:28:31 -0400
Received: from terminus.zytor.com ([192.83.249.54]:46737 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbXFAW2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:28:30 -0400
Message-ID: <46609D88.4040806@zytor.com>
Date: Fri, 01 Jun 2007 15:28:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Lee Revell <rlrevell@joe-job.com>
CC: Matthew Fredrickson <creslin@digium.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Device Driver Etiquette
References: <a714c0e137cf5cf814e790e3fdef23c8@digium.com> <75b66ecd0706011138v25e0d352p2fe5c4b5b8933046@mail.gmail.com>
In-Reply-To: <75b66ecd0706011138v25e0d352p2fe5c4b5b8933046@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Revell wrote:
> On 6/1/07, Matthew Fredrickson <creslin@digium.com> wrote:
>> is it acceptable (although
>> not nice) to simply fix it this way, by disabling irqs while it loads
>> the firmware?
>>
> 
> I would say to just disable IRQs while loading firmware.  Almost every
> server I maintain has some vendor driver which generates a "many lost
> ticks!" message on load.  As long as it's only done at module load
> time it should be fine.
> 
> Of course the best solution is to just get the driver into mainline.
> 

Disable interrupts for 5-10 seconds (see OP)?  You're nuts.

That might be only a minor disaster on an SMP system, assuming IRQ
balancing sends them elsewhere, but on a uniprocessor system you're
effectively shooting the machine in the head.

It should be possible to streamline the code to not hog the stack that way.

	-hpa

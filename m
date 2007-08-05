Return-Path: <linux-kernel-owner+w=401wt.eu-S1761557AbXHEOcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557AbXHEOcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 10:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758020AbXHEOcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 10:32:10 -0400
Received: from homer.mvista.com ([63.81.120.155]:62723 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756646AbXHEOcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 10:32:08 -0400
Message-ID: <46B5DFE0.4060008@ru.mvista.com>
Date: Sun, 05 Aug 2007 18:34:08 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: libata git tree, mbox queue status and contents
References: <46B35344.3090208@garzik.org> <20070803172040.52853316@the-village.bc.nu>
In-Reply-To: <20070803172040.52853316@the-village.bc.nu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

>>* Alan: IORDY handling -- upstream whenever Alan is happy

> I'm happy with it from testing. Just a little worried about it going
> upstream mid -rc as it could have a weird side effect somewhere. I've
> verified an original pre ATA IDE drive with it too now 8)

>>* Alan: ACPI checks for 80wire cable -- upstream whenever Alan is happy

> Happy

>>* Albert: irq_on/off.  Really need to give this some thought.  Not sure 
>>I like where this model is going.  Polling and twiddling irq on/off 
>>should be kept to a minimum, because it's sorta an admission that the 
>>host state machine has broken down, and we need to bandaid.  Its a 
>>bandaid not a root-cause solution.

> I think of it more as an admission that the IDE design is lacking in a
> few areas. No suprise as its an emulation of a 15 year old interface that
> was normally used polled.

    Hehe, note that even host polling has always been racy the way ATA spec. 
described it: there was noting said about the period whithin which the device 
should assert INTRQ after clearing BSY (and the interrupt-pending state wasn't 
clearly specified also), so there's a possibility for the fast host to *not* 
clear interrupt pending by reading the status reg. with BSY=0 but before the 
devie enters interrupt-pending state, and thus possibly stalling the further 
transfer.

MBR, Sergei

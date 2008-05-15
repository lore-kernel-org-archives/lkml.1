Return-Path: <linux-kernel-owner+w=401wt.eu-S1759223AbYEOUpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223AbYEOUpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYEOUpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:45:01 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39392 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbYEOUpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:45:00 -0400
Message-ID: <482CA0C8.7020808@garzik.org>
Date: Thu, 15 May 2008 16:44:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, virtualization@lists.osdl.org,
       Rusty Russell <rusty@rustcorp.com.au>, jeremy@xensource.com,
       Herbert Xu <herbert@gondor.apana.org.au>, Avi Kivity <avi@qumranet.com>,
       dor.laor@qumranet.com
Subject: Re: Virt RNG?
References: <482C8595.5030509@garzik.org> <200805152231.56967.borntraeger@de.ibm.com>
In-Reply-To: <200805152231.56967.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Am Donnerstag, 15. Mai 2008 schrieb Jeff Garzik:
>> Has anyone yet written a "hw" RNG module for virt, that reads the host's 
>> random number pool?
>>
>> All this talk[1] about IRQF_SAMPLE_RANDOM in network drivers reminds me 
>> that virt guest instances should be grabbing random numbers from the 
>> host, especially if the host has a hardware RNG.
> 
> Yes, there was a drivers/char/hw_random/virtio-rng.c in Rusty's lguest 
> repository. 
> http://www.mail-archive.com/virtualization%40lists.linux-foundation.org/msg02902.html
> 
> I have tested this driver with this fix
> https://lists.linux-foundation.org/pipermail/virtualization/2008-January/009737.html
> and it worked.

Nice!



> As it transfers only 4 byte per hypercall it is not mindblowingly fast, but I 
> guess it is fast enough.

A limitation of the hw-random API.  However, I'd say the virtio rng 
driver could (and should) buffer bigger chunks, say at least a 
cacheline's worth of data, to return via hw-random's 32-bit data request 
API.

	Jeff




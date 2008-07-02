Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbYGBLUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbYGBLUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760496AbYGBLTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:19:42 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:58882 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758992AbYGBLTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:19:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DTdcv7ukvneqhciErXvDYyFqoMndKlRnv+OhcIn/WwnhIyKbqGDvHkkEzJJcSfxlp9
         PFIVIok2WSemwf2AKn6am8J82zVESiLhzDkfDD6yvTGIelOR64MrHtk88HkyqrJG99/G
         j/IAwGq2cfoG5s715u3vlCtCbXcHwndhiwflA=
Message-ID: <c384c5ea0807020419o4d5b9ff1j34d4dc11a41dd2@mail.gmail.com>
Date: Wed, 2 Jul 2008 13:19:39 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [Ksummit-2008-discuss] Delayed interrupt work, thread pools
Cc: benh@kernel.crashing.org, "Arjan van de Ven" <arjan@linux.intel.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Jeremy Kerr" <jk@ozlabs.org>, RT <linux-rt-users@vger.kernel.org>
In-Reply-To: <87zlp0sg4l.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214916335.20711.141.camel@pasglop>
	 <486B0298.5030508@linux.intel.com> <1214977447.21182.33.camel@pasglop>
	 <87zlp0sg4l.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(including linux-rt-users in the CC:, irqthreads are on-topic there)

On Wed, Jul 2, 2008 at 1:02 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
>
>>> how much of this would be obsoleted if we had irqthreads ?
>>
>> I'm not sure irqthreads is what I want...
>>
> I also think interrupts threads are a bad idea in many cases because
> their whole "advantage" over classical interrupts is that they can
> block. Now blocking can be usually take a unbounded potentially long
> time.
>
> What do you do when there are more interrupts in that unbounded time?
>
If by irqthreads the -rt implementation is meant, isn't this what happens:

irq kernel handler masks the source interrupt
irq handler awakes the matching irqthread (they always are present)
irqthread is scheduled, does work and returns
irq kernel unmasks the source interrupt

> Create more interrupt threads?  At some point you'll have hundreds
> of threads doing nothing when you're unlucky.
>
Each irqthread handles one irq.
So now new irq thread would spawn for any interrupt.

Regards,
-- 
Leon

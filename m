Return-Path: <linux-kernel-owner+w=401wt.eu-S1767027AbXEBVSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767027AbXEBVSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423524AbXEBVSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:18:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423508AbXEBVSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:18:33 -0400
Message-ID: <4638FFB2.4000609@redhat.com>
Date: Wed, 02 May 2007 17:16:34 -0400
From: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] firewire: handling of cards, buses, nodes
References: <4637A29F.6070302@redhat.com>	 <20070502090007.GA28174@infradead.org>	 <tkrat.087ee29add656926@s5r6.in-berlin.de>	 <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <84144f020705020855q6e68381el899261fa30f60cc4@mail.gmail.com>
In-Reply-To: <84144f020705020855q6e68381el899261fa30f60cc4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On 5/2/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> +/* The lib/crc16.c implementation uses the standard (0x8005)
>> + * polynomial, but we need the ITU-T (or CCITT) polynomial (0x1021).
>> + * The implementation below works on an array of host-endian u32
>> + * words, assuming they'll be transmited msb first. */
>> +u16
>> +crc16_itu_t(const u32 *buffer, size_t length)
>> +{
> 
> [snip]
> 
> So put it in lib/crc-itu-t.c? Btw, there's apparently another ITU-T
> implementation floating around by Ivo van Doorn.

I looked into this a while back, and the kernel does have a CCITT based crc16 
function.  The problem is that it works on the opposite bit order from what I 
need, so to use it I'll have to bitswap every byte as it goes in and then 
bitswap the resulting crc16.  That's more code and probably less efficient 
than just implementing the crc itself.  I wouldn't mind moving it to lib/ 
though, but nobody else in the kernel is using this bit order.

Kristian


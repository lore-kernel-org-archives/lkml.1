Return-Path: <linux-kernel-owner+w=401wt.eu-S2993123AbXEBTQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993123AbXEBTQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993136AbXEBTQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:16:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34312 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993123AbXEBTQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:16:55 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4638E379.4050401@s5r6.in-berlin.de>
Date: Wed, 02 May 2007 21:16:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] firewire: handling of cards, buses, nodes
References: <4637A29F.6070302@redhat.com>	 <20070502090007.GA28174@infradead.org>	 <tkrat.087ee29add656926@s5r6.in-berlin.de>	 <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <84144f020705020855q6e68381el899261fa30f60cc4@mail.gmail.com>
In-Reply-To: <84144f020705020855q6e68381el899261fa30f60cc4@mail.gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
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

I looked around a bit with grep -R and a few search terms but didn't
find something definite.  Is there any other user of a crc16_itu_t or
crc_ccitt or whatever which operates on a (CPU byte ordered) u32[]
instead of on a (network byte ordered) u8[]?

The only value in having a shared implementation would be a potentially
smaller kernel.  Sharing it to ensure correctness is not an issue;
fw-topology.c::crc16_itu_t is simply the one in IEEE 1212 table 5.
Performance is also not an issue (if better algorithms exist) because
the FireWire stack uses it only infrequently on a moderate amount of data.
-- 
Stefan Richter
-=====-=-=== -=-= ---=-
http://arcgraph.de/sr/

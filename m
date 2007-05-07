Return-Path: <linux-kernel-owner+w=401wt.eu-S967079AbXEGWFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967079AbXEGWFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967067AbXEGWFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:05:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966561AbXEGWFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:05:01 -0400
Message-ID: <463FA20D.4040308@redhat.com>
Date: Mon, 07 May 2007 18:02:53 -0400
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
References: <4637A29F.6070302@redhat.com>	 <20070502090007.GA28174@infradead.org>	 <tkrat.087ee29add656926@s5r6.in-berlin.de>	 <tkrat.350cb4dfe522266e@s5r6.in-berlin.de>	 <84144f020705020855q6e68381el899261fa30f60cc4@mail.gmail.com>	 <4638E379.4050401@s5r6.in-berlin.de> <84144f020705021335i42473caei8f5421e91fd904dd@mail.gmail.com>
In-Reply-To: <84144f020705021335i42473caei8f5421e91fd904dd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On 5/2/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> I looked around a bit with grep -R and a few search terms but didn't
>> find something definite.  Is there any other user of a crc16_itu_t or
>> crc_ccitt or whatever which operates on a (CPU byte ordered) u32[]
>> instead of on a (network byte ordered) u8[]?
> 
> I was referring to this: http://lkml.org/lkml/2006/6/12/137

That works.  If you look closely, you can see that the ITU-T table is just

    crc_itu_t_table[i] = bitrev16(crc_ccitt_table[bitrev8(i)])

but that's a expensive enough operation that I think it deserves its own 
table.  Especially if there's another driver out there that needs this.

> On 5/2/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> The only value in having a shared implementation would be a potentially
>> smaller kernel.  Sharing it to ensure correctness is not an issue;
>> fw-topology.c::crc16_itu_t is simply the one in IEEE 1212 table 5.
>> Performance is also not an issue (if better algorithms exist) because
>> the FireWire stack uses it only infrequently on a moderate amount of 
>> data.
> 
> Yeah, it's not a biggie, but we do have a tradition of putting
> generally useful things into lib/ so that everyone doesn't invent
> their own.

I'll pull in Ivo's patch and add it to the firewire branch.

thanks,
Kristian

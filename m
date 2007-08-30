Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbXH3HXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbXH3HXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 03:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755180AbXH3HXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 03:23:10 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:33318 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754983AbXH3HXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 03:23:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Bx1agZ0JHK0Hq9hsfqSsrclEL0Hmn4KHwblXcoXdJdgawlPuyS78ZHE4UGu07fMGUySTMy68SLllO1j7rCD5M5n+goNKnDN3a6qJc8Rop4yA7UCN5yMJY78q8ZfpnPD7TgFWk7UiRvZBULJzOm4QpPQ07w7mtG+HSbj1U+brI0I=  ;
X-YMail-OSG: DLg1BA4VM1kagmPxl0nJ4LMmB9uWmSPoRbeBLZhy9rdZtiZL
Message-ID: <46D67057.9030905@yahoo.com.au>
Date: Thu, 30 Aug 2007 17:23:03 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Dave Airlie <airlied@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       dri-devel <dri-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: uncached page allocator
References: <21d7e9970708191745h3b579f3bp72f138e089c624da@mail.gmail.com>	 <20070820094125.209e0811@the-village.bc.nu>	 <21d7e9970708202305h5128aa5cy847dafe033b00742@mail.gmail.com> <1187708165.6114.256.camel@twins>
In-Reply-To: <1187708165.6114.256.camel@twins>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2007-08-21 at 16:05 +1000, Dave Airlie wrote:
> 
> 
>>So you can see why some sort of uncached+writecombined page cache
>>would be useful, I could just allocate a bunch of pages at startup as
>>uncached+writecombined, and allocate pixmaps from them and when I
>>bind/free the pixmap I don't need the flush at all, now I'd really
>>like this to be part of the VM so that under memory pressure it can
>>just take the pages I've got in my cache back and after flushing turn
>>them back into cached pages, the other option is for the DRM to do
>>this on its own and penalise the whole system.
> 
> 
> Can't you make these pages part of the regular VM by sticking them all
> into an address_space.
> 
> And for this reclaim behaviour you'd only need to set PG_private and
> have a_ops->releasepage() dtrt.

I'd just suggest Dave just registers a shrinker to start with.

You really want to be able to batch TLB flushes as well, which
->releasepage may not be so good at (you could add more machinery
behind the releasepage to build batches and so on, but anyway, a
shrinker might be the quickest way to get something working).

-- 
SUSE Labs, Novell Inc.

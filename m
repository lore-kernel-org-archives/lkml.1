Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923Ab0AEBqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab0AEBqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 20:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965Ab0AEBqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 20:46:12 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:47192 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab0AEBqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 20:46:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KB6NlncE30MHoVr3viIlCxxOihv3d+5HFvzAL/XIt5SQNUls8pMafLSplCHJJGgbw+
         1Ug4C3xM44ddMmG/4JiHfOegCXuDCfILUP1SVXkWpyHCweLELiHya4b4PuNvqFr1Byad
         P1Yz9gtiCh10zgtEuHcKt0OM9vp9gA/MhJwH4=
MIME-Version: 1.0
In-Reply-To: <20100104121642.GA12266@localhost>
References: <20091225000717.GA26949@yahoo-inc.com>
	 <87aax18xms.fsf@basil.nowhere.org> <20091230051540.GA16308@localhost>
	 <20091230052402.GB26364@localhost> <873a2s8hmp.fsf@basil.nowhere.org>
	 <20100104045020.GA21021@localhost>
	 <28c262361001032120v284e92b5ub1211f3d1fca6140@mail.gmail.com>
	 <20100104121642.GA12266@localhost>
Date: Tue, 5 Jan 2010 10:46:09 +0900
Message-ID: <28c262361001041746j1270e2d2i79a932efca861dc5@mail.gmail.com>
Subject: Re: [RFC][PATCH v3] readahead: introduce O_RANDOM for 
	POSIX_FADV_RANDOM
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 4, 2010 at 9:16 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> Hi Minchan,
>
> On Mon, Jan 04, 2010 at 01:20:49PM +0800, Minchan Kim wrote:
>> > --- linux.orig/mm/readahead.c   2010-01-04 12:39:29.000000000 +0800
>> > +++ linux/mm/readahead.c        2010-01-04 12:39:30.000000000 +0800
>> > @@ -501,6 +501,12 @@ void page_cache_sync_readahead(struct ad
>> >        if (!ra->ra_pages)
>> >                return;
>> >
>> > +       /* be dumb */
>> > +       if (filp->f_flags & O_RANDOM) {
>> > +               force_page_cache_readahead(mapping, filp, offset, req_size);
>> > +               return;
>> > +       }
>> > +
>>
>> Let me have a dumb question. :)
>>
>> How about testing O_RANDOM in front of ra_pages testing?
>>
>> My intention is that although we turn off ra, it would be better to read
>> contiguous block all at once than readpage() callback doing I/O
>> one page at a time.
>>
>> Is it break some semantics or happen some problem in ondemand readahead?
>
> Yes it will have some problem with shrink_readahead_size_eio(), which
> want to disable readahead and use ->readpage() when ra_pages==0.
>
> Do you have specific use case in mind? The file systems that set
> ra_pages=0 seems to don't need readahead, too.

Never mind. It's just out of curiosity. :)

I thought although user disable readahead, we could enhance file I/O
with one readpages not multiple readpage if we know the user want to
read big contiguous blocks.

But I though it break current readahead off semantics. right?

Thanks for reply about my dumb question, Wu. :)

>
> Thanks,
> Fengguang
>



-- 
Kind regards,
Minchan Kim

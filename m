Return-Path: <linux-kernel-owner+w=401wt.eu-S1751210AbZJUEIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbZJUEIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 00:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbZJUEH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 00:07:59 -0400
Received: from mail-px0-f171.google.com ([209.85.216.171]:36659 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbZJUEH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 00:07:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=tGxGGoFQlgN58rr4daSZqi7zPj1BTqmJhPyo0nhu4FO6/HIX0P8WqQuEzwVZ9f+2TD
         HjcM6RANZqOd/JqaC6F3Lt1aRCWECzgWzO9nj/f4CNUKZyo0GAXnkTwcvNL59ksRFF8j
         hmbTC3OjQwU+ntyBOuK9AohQvKTGlJ2ZZwS8Y=
MIME-Version: 1.0
In-Reply-To: <1256016346.12592.15.camel@heimdal.trondhjem.org>
References: <f2201a0b0910190116w29cd5e3w1ae2c76bd677f9ed@mail.gmail.com>
	 <1255940788.14447.7.camel@heimdal.trondhjem.org>
	 <6149e97b0910190138k5791351dmc95d9cc636aaef2f@mail.gmail.com>
	 <1256016346.12592.15.camel@heimdal.trondhjem.org>
Date: Wed, 21 Oct 2009 12:08:03 +0800
X-Google-Sender-Auth: 67717d75117e41fb
Message-ID: <6149e97b0910202108i3f66bdfesa4425ed1eab8bcb8@mail.gmail.com>
Subject: Re: Question about invalidate_inode_pages2_range()
From: Peng Tao <lkml.bergwolf@gmail.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 1:25 PM, Trond Myklebust
<trond.myklebust@fys.uio.no> wrote:
> On Mon, 2009-10-19 at 16:38 +0800, Peng Tao wrote:
>> On Mon, Oct 19, 2009 at 4:26 PM, Trond Myklebust
>> <trond.myklebust@fys.uio.no> wrote:
>> > On Mon, 2009-10-19 at 16:16 +0800, Peng Tao wrote:
>> >> Hi,
>> >>
>> >> I've a question about invalidate_inode_pages2_range().
>> >>
>> >> When does invalidate_inode_pages2_range() returns -EBUSY? It locks and
>> >> writes back the page. Why invalidate_complete_page2() still may fail
>> >> due to page dirtiness?
>> >
>> > A lot of those requirements were set by NFS, which uses
>> > invalidate_inode_pages2() in order to invalidate the page cache when it
>> > detects that a file has been changed on the server (either due to an
>> > O_DIRECT write, or due to another client modifying the file).
>> >
>> > In such cases, you want to try to keep the dirty data by writing it out
>> > instead of discarding it.
>> Thanks for your quick response. But I have two more questions about this.
>> 1. invalidate_inode_pages2_range() calls wait_on_page_writeback().
>> Does the latter actually write out the dirty page?
>
> No. It just waits for any outstanding writeback activity on that page to
> finish.
Got it. Thank you.
>
>> 2. Is there any interface in the mm subsystem forces discarding a page cache?
>
> You mean that also discards dirty pages? Yes. That is what
> truncate_inode_pages() does...
But truncate_inode_pages() truncates all pages beyond lstart.
Is there any way to discard a single page?
truncate_inode_page() seems to be able to do the magic. But it is not exported.

>
>
>



-- 
Cheers,
Peng Tao
State Key Laboratory of Networking and Switching Technology
Beijing Univ. of Posts and Telecoms.

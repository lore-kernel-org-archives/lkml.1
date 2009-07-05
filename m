Return-Path: <linux-kernel-owner+w=401wt.eu-S1757143AbZGEPEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbZGEPEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 11:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbZGEPEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 11:04:15 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:35169 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbZGEPEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 11:04:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gJWXPe2i0+vaIZd/ur54qoYQ447hiS2bZUYzi8XztrHAgmq4GvTmVpjfG4qNK3+qUI
         QmElNLI5E1eAfDZuIpxqGewxUFHJ1dCApnn1vBBRfyjzpr9XAzeIvfjIWUWu1IOXV47e
         0HIZkMV9xiQMsBEeJnJUsOtXRy6t+jPqc1pqk=
MIME-Version: 1.0
In-Reply-To: <2f11576a0907050619t5dea33cfwc46344600c2b17b5@mail.gmail.com>
References: <20090705182533.0902.A69D9226@jp.fujitsu.com>
	 <20090705121308.GC5252@localhost>
	 <20090705211739.091D.A69D9226@jp.fujitsu.com>
	 <20090705130200.GA6585@localhost>
	 <2f11576a0907050619t5dea33cfwc46344600c2b17b5@mail.gmail.com>
Date: Mon, 6 Jul 2009 00:04:17 +0900
Message-ID: <28c262360907050804p70bc293uc7330a6d968c0486@mail.gmail.com>
Subject: Re: [PATCH 5/5] add NR_ANON_PAGES to OOM log
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 5, 2009 at 10:19 PM, KOSAKI
Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
>>> > > + printk("%ld total anon pages\n", global_page_state(NR_ANON_PAGES));
>>> > >   printk("%ld total pagecache pages\n", global_page_state(NR_FILE_PAGES));
>>> >
>>> > Can we put related items together, ie. this looks more friendly:
>>> >
>>> >         Anon:XXX active_anon:XXX inactive_anon:XXX
>>> >         File:XXX active_file:XXX inactive_file:XXX
>>>
>>> hmmm. Actually NR_ACTIVE_ANON + NR_INACTIVE_ANON != NR_ANON_PAGES.
>>> tmpfs pages are accounted as FILE, but it is stay in anon lru.
>>
>> Right, that's exactly the reason I propose to put them together: to
>> make the number of tmpfs pages obvious.
>>
>>> I think your proposed format easily makes confusion. this format cause to
>>> imazine Anon = active_anon + inactive_anon.
>>
>> Yes it may confuse normal users :(
>>
>>> At least, we need to use another name, I think.
>>
>> Hmm I find it hard to work out a good name.
>>
>> But instead, it may be a good idea to explicitly compute the tmpfs
>> pages, because the excessive use of tmpfs pages could be a common
>> reason of OOM.
>
> Yeah,  explicite tmpfs/shmem accounting is also useful for /proc/meminfo.

Do we have to account it explicitly?

If we know the exact isolate pages of each lru,

tmpfs/shmem = (NR_ACTIVE_ANON + NR_INACTIVE_ANON + isolate(anon)) -
NR_ANON_PAGES.

Is there any cases above equation is wrong ?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Kind regards,
Minchan Kim

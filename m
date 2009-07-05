Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbZGEP11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbZGEP11 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 11:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZGEP1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 11:27:20 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:33958 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbZGEP1T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 11:27:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VlH+r19sLpr6dVfkP94TZ5Byj5aYFTTDaLk7lfADPilylmIjTEbUoAIpG0GMHr2+PL
         bADLUJOl8HQZHO13GZU3tvcI29OtLfpj96mCOCNy+xj+1Qk63OacLgoaBeAM0VZ2CLSU
         uqM6BDMY2fSD+EFfJ9YPotWJyCZMTu+221l4o=
MIME-Version: 1.0
In-Reply-To: <20090705151628.GA11307@localhost>
References: <20090705182533.0902.A69D9226@jp.fujitsu.com>
	 <20090705121308.GC5252@localhost>
	 <20090705211739.091D.A69D9226@jp.fujitsu.com>
	 <20090705130200.GA6585@localhost>
	 <2f11576a0907050619t5dea33cfwc46344600c2b17b5@mail.gmail.com>
	 <28c262360907050804p70bc293uc7330a6d968c0486@mail.gmail.com>
	 <20090705151628.GA11307@localhost>
Date: Mon, 6 Jul 2009 00:27:20 +0900
Message-ID: <28c262360907050827y577c3859g5e05e82935e96010@mail.gmail.com>
Subject: Re: [PATCH 5/5] add NR_ANON_PAGES to OOM log
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 6, 2009 at 12:16 AM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> On Sun, Jul 05, 2009 at 11:04:17PM +0800, Minchan Kim wrote:
>> On Sun, Jul 5, 2009 at 10:19 PM, KOSAKI
>> Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
>> >>> > > + printk("%ld total anon pages\n", global_page_state(NR_ANON_PAGES));
>> >>> > >   printk("%ld total pagecache pages\n", global_page_state(NR_FILE_PAGES));
>> >>> >
>> >>> > Can we put related items together, ie. this looks more friendly:
>> >>> >
>> >>> >         Anon:XXX active_anon:XXX inactive_anon:XXX
>> >>> >         File:XXX active_file:XXX inactive_file:XXX
>> >>>
>> >>> hmmm. Actually NR_ACTIVE_ANON + NR_INACTIVE_ANON != NR_ANON_PAGES.
>> >>> tmpfs pages are accounted as FILE, but it is stay in anon lru.
>> >>
>> >> Right, that's exactly the reason I propose to put them together: to
>> >> make the number of tmpfs pages obvious.
>> >>
>> >>> I think your proposed format easily makes confusion. this format cause to
>> >>> imazine Anon = active_anon + inactive_anon.
>> >>
>> >> Yes it may confuse normal users :(
>> >>
>> >>> At least, we need to use another name, I think.
>> >>
>> >> Hmm I find it hard to work out a good name.
>> >>
>> >> But instead, it may be a good idea to explicitly compute the tmpfs
>> >> pages, because the excessive use of tmpfs pages could be a common
>> >> reason of OOM.
>> >
>> > Yeah,  explicite tmpfs/shmem accounting is also useful for /proc/meminfo.
>>
>> Do we have to account it explicitly?
>
> When OOM happens, one frequent question to ask is: are there too many
> tmpfs/shmem pages?  Exporting this number makes our oom-message-decoding
> life easier :)

Indeed.

>> If we know the exact isolate pages of each lru,
>>
>> tmpfs/shmem = (NR_ACTIVE_ANON + NR_INACTIVE_ANON + isolate(anon)) -
>> NR_ANON_PAGES.
>>
>> Is there any cases above equation is wrong ?
>
> That's right, but the calculation may be too complex (and boring) for
> our little brain ;)

Yes. if something is change in future or we miss someting, the above
question may be wrong.
I wanted to remove overhead of new accouting.

Anyway, I think it's not a big cost in normal system.
So If you want to add new accounting, I don't have any objection. :)

> Thanks,
> Fengguang
>



-- 
Kind regards,
Minchan Kim

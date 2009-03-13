Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbZCMJUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbZCMJUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbZCMJTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:19:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:57807 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbZCMJTt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:19:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A89M/ibAoCEkifVZ4n/KIUoQ14Vr7ljexqijhl2ndDTm2qab//p7bTZ1VEmLC+Yr6p
         /u0Lwzyp/siWRieJNwo66uZzon27FSTUj0//FvvDzYTHP8f5i3jyQEuAr5NJeH+nLbUG
         FwKqu0B9JxTSw+PzgTc4RLCofiJ/7i84yhscs=
MIME-Version: 1.0
In-Reply-To: <20090313170058.6840.A69D9226@jp.fujitsu.com>
References: <20090313105618.43DF.A69D9226@jp.fujitsu.com>
	 <1236931036.5188.80.camel@laptop>
	 <20090313170058.6840.A69D9226@jp.fujitsu.com>
Date: Fri, 13 Mar 2009 18:19:47 +0900
Message-ID: <28c262360903130219n49485732p37c6f55b281f4b0@mail.gmail.com>
Subject: Re: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache may 
	get wrongly discarded
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       Enrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 5:15 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> > > >         The ramfs stuff is rather icky in that it adds the pages to the aging
>> > > >         list, marks them dirty, but does not provide a writeout method.
>> > > >
>> > > >         This will make the paging code scan over them (continuously) trying to
>> > > >         clean them, failing that (lack of writeout method) and putting them back
>> > > >         on the list.
>> > > >
>> > > > Not requiring the pages to be added to the LRU would be a really good idea.
>> > > > They are not discardable, be it in MMU or NOMMU mode, except when the inode
>> > > > itself is discarded.
>> > >
>> > > Yep, these pages shouldn't be on the LRU at all.  I guess that will
>> > > require some tweaks to core filemap.c code.
>> >
>> > IMHO, UNEVICTABLE_LRU already does lru isolation.
>> > only rest prblem is, getting rid of "depends on MMU" line in mm/Kconfig.
>> >
>> > Am I missing anything?
>>
>> Yes, the need to take something off that shouldn't be there to begin
>> with.
>
> In past unevictable lru discussion, we discuss the same thing.
> at that time, we found two reason of unevictable lru is better than
> completely taking off.
>
> (1) page migration code depend on the page stay on lru.
> (2) "taking off at reclaim time" can avoid adding lock to fastpath.
>    anyway, complely removing from lru need something lock.
>    we disliked it at that time

Can you explain this issue more detail when you are in convenience, please ?

> So, I think it is still true.
> Of cource, better cool solution is always welcome :)
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Kinds regards,
Minchan Kim

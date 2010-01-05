Return-Path: <linux-kernel-owner+w=401wt.eu-S1752332Ab0AEGAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab0AEGAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 01:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146Ab0AEGAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 01:00:44 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:53144 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab0AEGAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 01:00:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GdlPaoE8cVTDiX0i5UD0Aq8KUMeF+Jh/dQb/RNHvYLd4bh+6rYv4yS/rCjksuZMBcN
         vxRKGEVH+7q8tPHmQCrbZUQIWGyr9xAdZzIHfA9cdNqqU9wa7jubsXBk+Ewp8BmaS6tG
         1zJiRxai+nHT1TXH9wR7mTVMZ1mfBOry5HlTw=
MIME-Version: 1.0
In-Reply-To: <20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100104182429.833180340@chello.nl>
	 <20100104182813.753545361@chello.nl>
	 <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>
	 <28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com>
	 <20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 5 Jan 2010 15:00:42 +0900
Message-ID: <28c262361001042200k3e5a5ef9v42400120cbd33b61@mail.gmail.com>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 5, 2010 at 1:43 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 5 Jan 2010 13:29:40 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> Hi, Kame.
>>
>> On Tue, Jan 5, 2010 at 9:25 AM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > On Mon, 04 Jan 2010 19:24:35 +0100
>> > Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> >
>> >> Generic speculative fault handler, tries to service a pagefault
>> >> without holding mmap_sem.
>> >>
>> >> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> >
>> >
>> > I'm sorry if I miss something...how does this patch series avoid
>> > that vma is removed while __do_fault()->vma->vm_ops->fault() is called ?
>> > ("vma is removed" means all other things as freeing file struct etc..)
>>
>> Isn't it protected by get_file and iget?
>> Am I miss something?
>>
> Only kmem_cache_free() part of following code is modified by the patch.

That's it I missed. Thanks, Kame. ;-)
-- 
Kind regards,
Minchan Kim

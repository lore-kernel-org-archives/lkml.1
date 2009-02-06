Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbZBFKGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbZBFKGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 05:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbZBFKGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 05:06:36 -0500
Received: from el-out-1112.google.com ([209.85.162.180]:35961 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbZBFKGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 05:06:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IHrRL4OWjcMureVACdH+Odd3iEQHQr89rJIW6T18kIc95QPJ8noCQy0JAYJpKxx0XI
         +LHPiZfzrb7Xxu/kPfewOoxXlrWR59Q5fuVCzvLaC0eWVRZvt93JVfsz67m4me5DAgNF
         PcQPbeSBS8jfe8l1Yzb6Qk/+up2VgX5tlFmic=
MIME-Version: 1.0
In-Reply-To: <20090206080354.GA6516@barrios-desktop>
References: <20090206031125.693559239@cmpxchg.org>
	 <20090206031324.004715023@cmpxchg.org>
	 <20090206080354.GA6516@barrios-desktop>
Date: Fri, 6 Feb 2009 19:06:34 +0900
Message-ID: <28c262360902060206h78c15a1dsf52b481c5cc1bc74@mail.gmail.com>
Subject: Re: [PATCH 3/3][RFC] swsusp: shrink file cache first
From: MinChan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 6, 2009 at 5:03 PM, MinChan Kim <minchan.kim@gmail.com> wrote:
> Hi, Johannes.
> I have some questions.
> Just out of curiosity. :)
>
> On Fri, Feb 06, 2009 at 04:11:28AM +0100, Johannes Weiner wrote:
>> File cache pages are saved to disk either through normal writeback by
>> reclaim or by including them in the suspend image written to a
>> swapfile.
>>
>> Writing them either way should take the same amount of time but doing
>> normal writeback and unmap changes the fault behaviour on resume from
>> prefault to on-demand paging, smoothening out resume and giving
>
> What do you mean "unmap"?
> Why normal writeback and unmap chnages the fault behavior on resume ?

Please, Ignore poor first my question. :(
I agree with your opinion.

>> previously cached pages the chance to stay out of memory completely if
>> they are not used anymore.
>>
>> Another reason for preferring file page eviction is that the locality
>> principle is visible in fault patterns and swap might perform really
>> bad with subsequent faulting of contiguously mapped pages.
>
> Why do you think that swap might perform bad with subsequent faulting
> of contiguusly mapped page ?
> You mean normal file system is faster than swap due to readahead and
> smart block of allocation ?

But, I still can't understand this issue.
what mean "page eviction" ? Is it reclaim or swap out ?

>
> --
> Kinds Regards
> MinChan Kim
>
>



-- 
Kinds regards,
MinChan Kim

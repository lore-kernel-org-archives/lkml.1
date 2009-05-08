Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbZEHIvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbZEHIvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 04:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbZEHIv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 04:51:27 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:47850 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZEHIvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 04:51:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FhS18sEbpXf0C13YkDRiJMrZQoAn6UKPi741Msxly4iIKlDmagL90MJlCl3x6Ig4E8
         06L9vVSvnquNTCcJc4tLaKVWi3S7bWnPFm7AE4gBRJOeywG8ExYVDPFB7dq11ndx76zC
         GqLtIavQH36ufzode7VDOaC0Zk+BDxhtHxDK8=
MIME-Version: 1.0
In-Reply-To: <20090505212139.GA2559@cmpxchg.org>
References: <20090501181449.GA8912@cmpxchg.org>
	 <1241430874-12667-1-git-send-email-hannes@cmpxchg.org>
	 <20090505122442.6271c7da.akpm@linux-foundation.org>
	 <20090505203807.GB2428@cmpxchg.org>
	 <20090505140517.bef78dd3.akpm@linux-foundation.org>
	 <20090505212139.GA2559@cmpxchg.org>
Date: Fri, 8 May 2009 17:51:24 +0900
Message-ID: <aec7e5c30905080151q5a4f4ebq1e743b534a5fc84a@mail.gmail.com>
Subject: Re: [patch 1/3] mm: introduce follow_pte()
From: Magnus Damm <magnus.damm@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-media@vger.kernel.org,
       hverkuil@xs4all.nl, lethal@linux-sh.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 6, 2009 at 6:21 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Tue, May 05, 2009 at 02:05:17PM -0700, Andrew Morton wrote:
>> On Tue, 5 May 2009 22:38:07 +0200
>> Johannes Weiner <hannes@cmpxchg.org> wrote:
>> > On Tue, May 05, 2009 at 12:24:42PM -0700, Andrew Morton wrote:
>> > > On Mon,  4 May 2009 11:54:32 +0200
>> > > Johannes Weiner <hannes@cmpxchg.org> wrote:
>> > >
>> > > > A generic readonly page table lookup helper to map an address space
>> > > > and an address from it to a pte.
>> > >
>> > > umm, OK.
>> > >
>> > > Is there actually some point to these three patches?  If so, what is it?
>> >
>> > Magnus needs to check for physical contiguity of a VMAs backing pages
>> > to support zero-copy exportation of video data to userspace.
>> >
>> > This series implements follow_pfn() so he can walk the VMA backing
>> > pages and ensure their PFNs are in linear order.
>> >
>> > [ This patch can be collapsed with 2/3, I just thought it would be
>> >   easier to read the diffs when having them separate. ]
>> >
>> > 1/3 and 2/3: factor out the page table walk from follow_phys() into
>> > follow_pte().
>> >
>> > 3/3: implement follow_pfn() on top of follow_pte().
>>
>> So we could bundle these patches with Magnus's patchset, or we could
>> consider these three patches as a cleanup or something.
>>
>> Given that 3/3 introduces an unused function, I'm inclined to sit tight
>> and await Magnus's work.
>
> Yeah, I didn't see the video guys responding on Magnus' patch yet, so
> let's wait for them.
>
> Magnus, the actual conversion of your code should be trivial, could
> you respin it on top of these three patches using follow_pfn() then?

So I tested the patches in -mm (1/3, 2/3, 3/3) together with the zero
copy patch and everything seems fine. Feel free to add acks from me,
least for patch 1/3 and 3/3 - i know too little about the generic case
to say anything about 2/3.

Acked-by: Magnus Damm <damm@igel.co.jp>

I'll send V3 of my zero copy patch in a little while. Thanks a lot for the help!

Cheers,

/ magnus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612AbZJXNq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbZJXNq5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 09:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZJXNq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 09:46:56 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34231 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbZJXNqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 09:46:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eKyh7lqdslux5GekYYe4JHu8IpcKBxcIW2nXlRBOcWxxJbIcPsotoNE4gLsuKI676k
         iI624j/BOJxC3ey3CjaNUqGdZ+utvLfuFzJEYjD+8KrJW2FoJF9mYEf+EYpE1AJIfODD
         fWwrKm9v3u7nmA41Y3cBWN3FVgN4Nat1cZQkk=
MIME-Version: 1.0
In-Reply-To: <20091023211239.GA6185@bizet.domek.prywatny>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie>
	 <20091023165810.GA4588@bizet.domek.prywatny>
	 <20091023211239.GA6185@bizet.domek.prywatny>
Date: Sat, 24 Oct 2009 14:46:56 +0100
Message-ID: <9ec2d7290910240646p75b93c68v6ea1648d628a9660@mail.gmail.com>
Subject: Re: [PATCH 0/5] Candidate fix for increased number of GFP_ATOMIC 
	failures V2
From: Mel LKML <mel.lkml@gmail.com>
To: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Frans Pop <elendil@planet.nl>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Tobias Oetiker <tobi@oetiker.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the same Mel as mel@csn.ul.ie. The mail server the address is
on has no power until Tuesday so I'm not going to be very unresponsive
until then. Monday is also a public holiday here and apparently they
are upgrading the power transformers near the building.

On 10/23/09, Karol Lewandowski <karol.k.lewandowski@gmail.com> wrote:
> On Fri, Oct 23, 2009 at 06:58:10PM +0200, Karol Lewandowski wrote:
>> On Thu, Oct 22, 2009 at 03:22:31PM +0100, Mel Gorman wrote:
>> > Test 3: If you are getting allocation failures, try with the following
>> > patch
>> >
>> >   3/5 vmscan: Force kswapd to take notice faster when high-order
>> > watermarks are being hit
>
>> No, problem doesn't go away with these patches (1+2+3).  However, from
>> my testing this particular patch makes it way, way harder to trigger
>> allocation failures (but these are still present).
>>
>> This bothers me - should I test following patches with or without
>> above patch?  This patch makes bug harder to find, IMVHO it doesn't
>> fix the real problem.
> ..
>
>> Test 4: If you are still getting failures, apply the following
>>  4/5 page allocator: Pre-emptively wake kswapd when high-order watermarks
>> are hit
>
> Ok, I've tested patches 1+2+4 and bug, while very hard to trigger, is
> still present. I'll test complete 1-4 patchset as time permits.
>

And also patch 5 please which is the revert. Patch 5 as pointed out is
probably a red herring. Hwoever, it has changed the timing and made a
difference for some testing so I'd like to know if it helps yours as
well.

As things stand, it looks like patches 1+2 should certainly go ahead.
I need to give more thought on patches 3 and 4 as to why they help
Tobias but not anyone elses testing.

Thanks

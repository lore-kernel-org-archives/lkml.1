Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbZETKxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbZETKxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 06:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbZETKxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 06:53:31 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:55352 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbZETKxa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 06:53:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bEsdTO/JHyZH4AJvGOWvGgM2nK2AU2LcFyVb9uWoZITFGCE/enYdcP+A+X2CLkk3u6
         qlpQ/LyTO0FUJHojFwu7b7PvZmY2vsjVtYe5laZzdMziEK4QEcnR4EYa5OJ23rvaikEg
         52UPSvsjp7K+6uUB9r4XipFBQzKeDBt9eoqjE=
MIME-Version: 1.0
In-Reply-To: <20090520104739.GD12433@csn.ul.ie>
References: <20090520161853.1bfd415c.minchan.kim@barrios-desktop>
	 <20090520085416.GA27056@csn.ul.ie>
	 <20090520185803.e5b0698a.minchan.kim@barrios-desktop>
	 <20090520102129.GA12433@csn.ul.ie>
	 <20090520193045.2070f7fa.minchan.kim@barrios-desktop>
	 <20090520104739.GD12433@csn.ul.ie>
Date: Wed, 20 May 2009 19:53:30 +0900
Message-ID: <28c262360905200353x60af7141gc73e491c2c7d17a3@mail.gmail.com>
Subject: Re: [PATCH 1/3] clean up setup_per_zone_pages_min
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 7:47 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Wed, May 20, 2009 at 07:30:45PM +0900, Minchan Kim wrote:
>> On Wed, 20 May 2009 11:21:29 +0100
>> Mel Gorman <mel@csn.ul.ie> wrote:
>>
>> > On Wed, May 20, 2009 at 06:58:03PM +0900, Minchan Kim wrote:
>> > > Hi, Mel.
>> > >
>> > > On Wed, 20 May 2009 09:54:16 +0100
>> > > Mel Gorman <mel@csn.ul.ie> wrote:
>> > >
>> > > > On Wed, May 20, 2009 at 04:18:53PM +0900, Minchan Kim wrote:
>> > > > >
>> > > > > Mel changed zone->pages_[high/low/min] with zone->watermark array.
>> > > > > So, setup_per_zone_pages_min also have to be changed.
>> > > > >
>> > > >
>> > > > Just to be clear, this is a function renaming to match the new zone
>> > > > field name, not something I missed. As the function changes min, low and
>> > > > max, a better name might have been setup_per_zone_watermarks but whether
>> > >
>> > > At first, I thouht, too. But It's handle of min_free_kbytes.
>> > > Documentation said, it's to compute a watermark[WMARK_MIN].
>> > > I think many people already used that knob to contorl pages_min to keep the
>> > > low pages.
>> >
>> > Which documentation?
>>
>> Documentation/sysctl/vm.txt - min_free_kbytes.
>>
>
> That documentation states
>
> ====
> This is used to force the Linux VM to keep a minimum number
> of kilobytes free.  The VM uses this number to compute a pages_min
> value for each lowmem zone in the system.  Each lowmem zone gets
> a number of reserved free pages based proportionally on its size.
> ====
>
> This is true. It just happens in the implementation that sets pages_min
> (or it's renamed value) also sets the low and high watermarks are also set
> based on the value of the minimum value. It doesn't need to be updated.
>

Okay.
I will modify function name with setup_per_zone_watermarks at next version.
Thanks for careful review, Mel.


-- 
Kinds regards,
Minchan Kim

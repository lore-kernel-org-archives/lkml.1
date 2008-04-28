Return-Path: <linux-kernel-owner+w=401wt.eu-S934031AbYD1MbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031AbYD1MbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 08:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765164AbYD1MbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 08:31:10 -0400
Received: from smtp.nokia.com ([192.100.122.230]:40951 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765067AbYD1MbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 08:31:09 -0400
Message-ID: <4815C239.5050800@nokia.com>
Date: Mon, 28 Apr 2008 15:25:29 +0300
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Artem Bityutskiy <dedekind@yandex.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 26/26] UBIFS: include FS to compilation
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com> <84144f020804010039n47133bd3l63f02258a2670e72@mail.gmail.com> <47F1F7A6.5020105@yandex.ru> <20080426093553.GA17730@infradead.org> <48157812.5090909@nokia.com> <20080428090032.GA14100@infradead.org> <4815B3AE.5010500@nokia.com> <20080428113932.GA27250@infradead.org>
In-Reply-To: <20080428113932.GA27250@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Apr 2008 12:30:24.0335 (UTC) FILETIME=[A1CD8DF0:01C8A92B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Apr 28, 2008 at 02:23:26PM +0300, Adrian Hunter wrote:
>>>>> But these don't make much sense to me. Why would you want to be able
>>>>> to compile out printks at this granularity? Why not enable all of them
>>>>> when CONFIG_UBIFS_FS_DEBUG is enabled? 
>>>> Well, its just more convenient for us. If I know the bug is somewhere in
>>>> the journal, I enable the journal messages - less flooding. We may
>>>> lessen the amount, but it is still handy to have some classes of
>>>> prints separate.
>>>>
>>>> We will think how to lessen the amount and granularity of this. 
> 
> note that this last line was _not_ quoted in my mail.
> 
>>>> Christoph Hellwig wrote:
>>>>> It's everything but convenient :)  Please make it one config option to
>>>>> compile in all debug code and then have a module option to select the
>>>>> verbosity level at runtime.
>>>> Surely that judgement should be made by people who actually debug UBIFS.
> 
>> You have gone off on a tangent.  The original context was discussing the
>> need for granulated debug messages.  I have restored the context above.
> 
> I think you haven't read my statement at all.  Please look at the quoted
> bit above.  There is nothing against having different
> vebosity/granularity levels, quite to the contrary.  I just told you
> that a run-time selection of them is everything but convenient and they
> should rather be at runtime. 
> 
>> You seem to have mistakenly inferred I was impugning your judgement.  That
>> was not the point.
> 
> No, the point was that you didn't read my message and/or assumes just
> because I'm not 100% on your line of reasoning I'm against you.
> 
>> Coming back to your issue of a mount-time option for debug messages.  I am
>> not sure any other file systems do that.  In general I would say having to
>> switch on the debug config option and also change either the kernel command
>> line or init scripts, seems in fact much less convenient.
> 
> It means you can be debug different bits without recompiling which is a
> very good thing.  Especially if you're debugging moves from one area to
> another.

At one stage Artem had set up sysfs entries for UBIFS so that he could change
debugging options via sysfs on the fly, without even unmounting.  But he said
he didn't find it that useful and removed it all.

For myself, recompiling UBIFS only takes 25 seconds so changing config options
is not a big deal.

However I have no problem adding a mount option, although I suspect we might
end up being asked to remove it.

I hope to spend some time on UBIFS debug message handling this week.  I would
like to be able to control verbosity, but not overcomplicate matters.  We plan
to post UBIFS again next week when Artem returns from holiday.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752247AbYEER5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbYEER5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbYEER4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:56:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:14360 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbYEER4x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:56:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,438,1204531200"; 
   d="scan'208";a="278072541"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [git head] Should X86_PAT really default to yes?
Date: Mon, 5 May 2008 10:59:27 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEEFB92EF@orsmsx423.amr.corp.intel.com>
In-Reply-To: <200805051045.31026.jesse.barnes@intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [git head] Should X86_PAT really default to yes?
Thread-Index: Aciu2CyMlmqa10D5SgSqDrPevid90gAAH+dg
References: <200805022122.03576.elendil@planet.nl> <200805050857.57661.jesse.barnes@intel.com> <200805051932.41827.elendil@planet.nl> <200805051045.31026.jesse.barnes@intel.com>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Barnes, Jesse" <jesse.barnes@intel.com>, "Frans Pop" <elendil@planet.nl>
Cc: <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Packard, Keith" <keith.packard@intel.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
X-OriginalArrivalTime: 05 May 2008 17:56:53.0004 (UTC) FILETIME=[66737CC0:01C8AED9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>-----Original Message-----
>From: Barnes, Jesse 
>Sent: Monday, May 05, 2008 10:46 AM
>To: Frans Pop
>Cc: Pallipadi, Venkatesh; linux-kernel@vger.kernel.org; Ingo 
>Molnar; Packard, Keith; Yinghai Lu
>Subject: Re: [git head] Should X86_PAT really default to yes?
>
>On Monday, May 05, 2008 10:32 am Frans Pop wrote:
>> Sigh. This is going to get complex...
>>
>> On Monday 05 May 2008, Jesse Barnes wrote:
>> > > > If so, it might not be a PAT issue but just a 
>different memory layout
>> > > > or something (and therefore it would really just be a 
>cosmetic bug in
>> > > > the X driver).
>> > >
>> > > The artifacts may not be a PAT issue directly, but it is a clear
>> > > regression for me as I currently have a nice clean 
>screen when X shuts
>> > > down. I'm also 100% sure that it is caused by enabling 
>PAT. A kernel
>> > > with same config and only PAT disabled does not show the 
>artifacts.
>> > >
>> > > Would you like me to file a bug against X for these artifacts?
>> > > If so, against what component? The i810 driver or the server?
>> >
>> > I suspect an i810 driver bug is being uncovered here, 
>since we do have
>> > transient VT switch corruption on some other platforms (we're just
>> > exposing our chip reprogramming on the screen, rather than 
>keeping it off
>> > the whole time).  But there could also be something PAT 
>specific going
>> > on, I'll have to walk through those code paths...
>>
>> I suspect it could be vesafb/fbcon related instead. Normally 
>I boot my
>> system with 'quiet vga=791', i.e. with vesafb. I then see 
>the artifacts.
>>
>> When I boot without 'vga=791', I hit another, unrelated 
>regression (which
>> I'll report separately) [1].
>>
>> When I boot with 'video=vfb:off', I do _not_ get the artifacts when X
>> exits.
>
>Ahhh, I missed that part of your config.  That could 
>definitely have an effect 
>on things...  You'll probably want something like the attached 
>(there are 
>other places in the fb layer that want similar treatment, iirc, maybe 
>fb_pgprotect?).
>
>> Note that the "expected mapping type" errors remain the same 
>both with and
>> without framebuffer console.
>>
>> > Oh the messages should be removed or somehow minimized, I 
>agree.  I'm
>> > just not sure if the other bug is serious enough to block 
>PAT by default
>> > yet, but either way we should fix the bugs!
>>
>> OK. Thanks. Guess you've also seen "Xorg crash with 
>xf86MapVidMem error"
>> that turned out to be due to PAT:
>> http://www.gossamer-threads.com/lists/linux/kernel/915300 ?
>
>No, I hadn't seen that...  Venki/Ingo has that issue been 
>fixed already?
>

No. We are following up on that issue to root cause the problem there.
AFAIK, that is the only other open issue related to PAT at this time.

There was another one reported here
http://bugzilla.kernel.org/show_bug.cgi?id=10580
which was root caused as a app bug unmasked by PAT.

Thanks,
Venki

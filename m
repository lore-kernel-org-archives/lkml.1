Return-Path: <linux-kernel-owner+w=401wt.eu-S932899AbZJFOyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbZJFOyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932722AbZJFOyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:54:50 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:53294 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632AbZJFOyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:54:49 -0400
X-SpamScore: -36
X-BigFish: VPS-36(zz542N1418M1432R98dN936eM9371P8c8aizz1202hz4ehzz32i29bh6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KR3LCY-01-6V1-02
X-M-MSG: 
Message-ID: <4ACB59E2.3000600@amd.com>
Date: Tue, 6 Oct 2009 10:53:22 -0400
From: "Tippett, Matthew" <matthew.tippett@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070618 Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Li, Samuel" <Samuel.Li@amd.com>
Subject: Re: [PATCH][ACPI] AC/DC notifier
References: <FFAE0590FF35E441901B67BD8BA62E950245ABD9@storexmb3.amd.com> <20090812005532.GA31003@srcf.ucam.org> <20090814163233.GC1626@ucw.cz> <20090816074008.GA11624@1wt.eu>
In-Reply-To: <20090816074008.GA11624@1wt.eu>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2009 14:53:22.0084 (UTC) FILETIME=[BFD2AE40:01CA4694]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending as text-only - sorry)

Bringing this item back up again.

I am not suggesting that the application of any particular policy 
appears within the kernel or userspace or a secondary policy engine.   
In general I am also against codifying policy within drivers.

I am interested seeing the ACPI notifier mechanism expanded to allow 
AC/DC state changes propagate to other kernel drivers without requiring 
a userspace in between.

I can continue to come up with real scenarios that would possibly 
require kernel-to-kernel notification, but would rather focus this 
discussion of the pure technical issues associated with adding the 
notifier to the AC/DC ACPI subsystem. 

Remember it is a one line patch.

Regards,

Matthew

-------- Original Message  --------
Subject: Re: [PATCH][ACPI] AC/DC notifier
From: Willy Tarreau <w@1wt.eu>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>, "Tippett, Matthew" 
<Matthew.Tippett@amd.com>, "Langsdorf, Mark" <mark.langsdorf@amd.com>, 
lenb@kernel.org, linux-acpi@vger.kernel.org, 
linux-kernel@vger.kernel.org, "Li, Samuel" <Samuel.Li@amd.com>
Date: 08/16/2009 03:40 AM
>
> On Fri, Aug 14, 2009 at 06:32:33PM +0200, Pavel Machek wrote:
> > On Wed 2009-08-12 01:55:32, Matthew Garrett wrote:
> > > On Tue, Aug 11, 2009 at 08:51:49PM -0400, Tippett, Matthew wrote:
> > >
> > > >    From a graphics perspective (your area of expertise), this 
> will allow KMS
> > > >    drivers to do some more intelligent actions based on the 
> ac/dc state.
> > > >    Some examples of this could be improving the power 
> consumption of the
> > > >    graphics hardware through adapting clock memory/engine 
> settings for
> > > >    reduced power consumption, reducing refresh rate of the 
> display to reduce
> > > >    scanout memory access, adjusting backlight brightness, etc.
> > >
> > > Right. As you say, my concern is that most of this should belong in
> > > userspace. Where we risk hardware damage there's an obvious 
> argument for
> > > doing this in kernel, but we should ensure that that's limited to
> > > whatever coarse-grain handling is absolutely required rather than 
> doing
> > > things like touching display brightness.
> >
> > Yep... Some may want to save power even when AC is online -- like when
> > running on UPS. Some may want max performmance even on battery.
>
> Wholeheartly agreed. IMHO, there's absolutely no relation between power
> source and the expected performance. It's really frustrating when your
> laptop becomes a snail on battery, as well as it's annoying to hear it
> sound like a hairdryer when plugged to mains. This should only be the
> user's choice. Mine automatically adjusts its frequency on demand,
> regardless of the power source, which provides me with the best
> experience. I think that all the tricks used to save power when running
> on battery were invented by laptop makers to artificially show longer
> lasting eventhough the machine sometimes becomes barely usable. For
> instance, some of them dim the backlight so that you can't read anything
> in full light, so you need a power prolongator to use them outside !
>
> Also, with the new trend of laptops making use of huge power-hungry 3D
> graphic chips which suck all the juice out of your battery in less than
> two hours doing nothing, you'd better run at full speed when on battery
> to save energy for CPU-bound tasks, because eventhough the CPU eats more
> power, you significantly reduce the run time, thus the static consumption
> (GPU, backlight, hard disk, ...).
>
> Willy
>
>




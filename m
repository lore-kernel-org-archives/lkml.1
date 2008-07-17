Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbYGQSFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbYGQSFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757583AbYGQSFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:05:31 -0400
Received: from hs-out-0708.google.com ([64.233.178.241]:49824 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760706AbYGQSF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:05:29 -0400
Message-ID: <fa686aa40807171105m22dda41dqb334dd5f7b2634d8@mail.gmail.com>
Date: Thu, 17 Jul 2008 12:05:28 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH v3] leds: implement OpenFirmare GPIO LED driver
Cc: "Trent Piepho" <tpiepho@freescale.com>,
       "Richard Purdie" <rpurdie@rpsys.net>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Kumar Gala" <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20080717152006.GA26120@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216133032.5345.73.camel@dax.rpnet.com>
	 <20080715151917.GA30607@polina.dev.rtsoft.ru>
	 <Pine.LNX.4.64.0807161546010.12709@t2.domain.actdsltmp>
	 <20080717041531.GA27243@secretlab.ca>
	 <20080717140519.GA32617@polina.dev.rtsoft.ru>
	 <20080717141335.GA2219@polina.dev.rtsoft.ru>
	 <20080717150422.GC31932@secretlab.ca>
	 <20080717152006.GA26120@polina.dev.rtsoft.ru>
X-Google-Sender-Auth: 5ac54ba3f692dca2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 9:20 AM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> On Thu, Jul 17, 2008 at 09:04:22AM -0600, Grant Likely wrote:
>> On Thu, Jul 17, 2008 at 06:13:35PM +0400, Anton Vorontsov wrote:
>> > On Thu, Jul 17, 2008 at 06:05:19PM +0400, Anton Vorontsov wrote:
>> > [...]
>> > > > I think it would be better to have a module that scans the device tree
>> > > > for LED nodes and registers a single leds-gpio platform device for the
>> > > > whole lot.
>> > > >
>> > > > Thoughts?
>> > >
>> > > I like the idea, thanks.
>> >
>> > Ugh, no. The idea sounds good, but in practice it isn't, since we'll
>> > have to handle suspend/resume ops ourselves. When we stick with the
>> > device/driver model we're getting all this for free.
>>
>> Won't the leds-gpio driver give you suspend/resume support?
>
> Ah. I just wrongly read your message. You're purposing to use gpio
> leds platform driver... I think this is doable, yes.

Alternately, I would also be okay with a scheme where all LED nodes
have a common parent and an of_platform driver would bind against the
parent node; not the individual children.  Then the leds-gpio driver
could be refactored to have both platform and of_platform bus
bindings.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

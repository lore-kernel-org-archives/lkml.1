Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbYG1UD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbYG1UD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYG1UDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:03:49 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:1940 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbYG1UDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:03:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OcOUhAxogyPv/6Ll+yjhRKUnFZa0w/TSsgjnerO9d2Kyg+6MxF3L0Au3TI4sLFvHUV
         wLXDq7vGDL4uiip1Wj3IAgPbs8737/mP+2Q5Tg9mRxQ0QcTKEenIEDsuXX1mtgk0knGu
         8w1tYIZ/t3yS0M6Fe2wGSVoIPYhDr1wrFwW2c=
Message-ID: <6179c79b0807281303s7b48d7c9xad2d4d1b407a4ad7@mail.gmail.com>
Date: Mon, 28 Jul 2008 22:03:46 +0200
From: "Piotr Skamruk" <piotr.skamruk@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH v2] Add GPIO-based MMC/SD driver
Cc: "David Brownell" <david-b@pacbell.net>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, gregkh <greg@kroah.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Pierre Ossman" <drzeus-mmc@drzeus.cx>, openwrt-devel@lists.openwrt.org
In-Reply-To: <200807281511.54299.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807182201.33913.mb@bu3sch.de>
	 <20080721135332.4ce02e0c.randy.dunlap@oracle.com>
	 <200807271630.07939.david-b@pacbell.net>
	 <200807281511.54299.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/28 Michael Buesch <mb@bu3sch.de>:
> On Monday 28 July 2008 01:30:07 David Brownell wrote:
>> > How to?
>>
>> Simplest to just rip out the support for using one!  And in any case:
>> as a rule, any delay should be a function of the target bus speed.
>
> Well, that wasn't exactly an answer to my question. ;)
> So setting boardinfo->max_speed_hz to zero will do?
David wants fastest code (so it could run optimally on embedded
devices), and Yours version is more overview.
IMHO both approach are right, but in diffrent situations.
If i need fastest implementation, which i could use on some special
device, probably i would wrote machine dependent platform device, with
inlined gpio calls, because this would be faster.
But, when i want more generic interface, which could be used in more
diffrent situations - i would preferre Michaels approach.

>> > Where's that documented?
>>
>> UTSL ... mmc_spi_probe(), first thing.  :)
:)

> [...]
>> > > There is no "platform GPIO bus" ...
>> >
>> > hm??
>>
>> If you look in /sys/bus you won't see GPIO.  It's not a bus.
>
> Oh well... This is getting boring...
> Then call it "platform GPIO pins" or "platform GPIO controller" or whatever.
> That's really just splitting the hair into 16 parts.
Michael - ok, change this to "platform GPIO lines" :)

>> > People asked me to expose it. It was hidden in the first patch that
>> > I submitted. I'm not going to change this just to see the next one
>> > yelling "I want to see this interface in public" again.
>>
>> Could you send me some URLs for that feedback?
>
> It was private. One of the OpenWRT guys requested that to have a
> convenient way to define a hardwired MMC card in the platform code
> by just defining a simple data structure.
Maybe I was this one, ore one of them. I wanted some method to
experiment with MMC/SD connected to GPIO. Not some determined lines,
but in some way configurable. There was several ugly patches on net
(mostly around OpenWRT, and mostly tested by users of OpenWRT), but
all of them was ugly hacks, dependent on some particular architecture
(ARM as i remember).
So, in that time, simply I started writing something more general,
less architecture dependent, something, what could be more easy to
configure (in kernel/module loading time).
I started this, and Michael did the rest...

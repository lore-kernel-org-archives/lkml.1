Return-Path: <linux-kernel-owner+w=401wt.eu-S1752159AbZH2KuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbZH2KuL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 06:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZH2KuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 06:50:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54531 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbZH2KuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 06:50:09 -0400
Date: Sat, 29 Aug 2009 12:09:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: David Woodhouse <dwmw2@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Ric Wheeler <rwheeler@redhat.com>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Message-ID: <20090829100909.GI1634@ucw.cz>
References: <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <1251362787.4354.373.camel@macbook.infradead.org> <alpine.DEB.2.00.0908280738140.6822@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908280738140.6822@asgard.lang.hm>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-08-28 07:46:42, david@lang.hm wrote:
> On Thu, 27 Aug 2009, David Woodhouse wrote:
>
>> On Mon, 2009-08-24 at 20:08 -0400, Theodore Tso wrote:
>>>
>>> (It's worse with people using Digital SLR's shooting in raw mode,
>>> since it can take upwards of 30 seconds or more to write out a 12-30MB
>>> raw image, and if you eject at the wrong time, you can trash the
>>> contents of the entire CF card; in the worst case, the Flash
>>> Translation Layer data can get corrupted, and the card is completely
>>> ruined; you can't even reformat it at the filesystem level, but have
>>> to get a special Windows program from the CF manufacturer to --maybe--
>>> reset the FTL layer.
>>
>> This just goes to show why having this "translation layer" done in
>> firmware on the device itself is a _bad_ idea. We're much better off
>> when we have full access to the underlying flash and the OS can actually
>> see what's going on. That way, we can actually debug, fix and recover
>> from such problems.
>>
>>>   Early CF cards were especially vulnerable to
>>> this; more recent CF cards are better, but it's a known failure mode
>>> of CF cards.)
>>
>> It's a known failure mode of _everything_ that uses flash to pretend to
>> be a block device. As I see it, there are no SSD devices which don't
>> lose data; there are only SSD devices which haven't lost your data
>> _yet_.
>>
>> There's no fundamental reason why it should be this way; it just is.
>>
>> (I'm kind of hoping that the shiny new expensive ones that everyone's
>> talking about right now, that I shouldn't really be slagging off, are
>> actually OK. But they're still new, and I'm certainly not trusting them
>> with my own data _quite_ yet.)
>
> so what sort of test would be needed to identify if a device has this  
> problem?
>
> people can do ad-hoc tests by pulling the devices in use and then 
> checking the entire device, but something better should be available.
>
> it seems to me that there are two things needed to define the tests.
>
> 1. a predictable write load so that it's easy to detect data getting lose
>
> 2. some statistical analysis to decide how many device pulls are needed  
> (under the write load defined in #1) to make the odds high that the  
> problem will be revealed.

Its simpler than that. It usually breaks after third unplug or so.

> for USB devices there may be a way to use the power management functions  
> to cut power to the device without requiring it to physically be pulled,  
> if this is the case (even if this only works on some specific chipsets),  
> it would drasticly speed up the testing

This is really so easy to reproduce, that such speedup is not
neccessary. Just try the scripts :-).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

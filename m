Return-Path: <linux-kernel-owner+w=401wt.eu-S1030457AbXBGAfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030457AbXBGAfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 19:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030352AbXBGAfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 19:35:53 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:53375 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030457AbXBGAfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 19:35:52 -0500
Message-ID: <45C91DB0.8060308@oracle.com>
Date: Tue, 06 Feb 2007 16:30:40 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
References: <1170801484.29759.1000.camel@pmac.infradead.org>  <Pine.LNX.4.64.0702061451560.8424@woody.linux-foundation.org>  <1170803515.29759.1032.camel@pmac.infradead.org>  <Pine.LNX.4.64.0702061516110.8424@woody.linux-foundation.org>  <1170804983.29759.1051.camel@pmac.infradead.org>  <Pine.LNX.4.64.0702061550010.8424@woody.linux-foundation.org> <1170806622.29759.1063.camel@pmac.infradead.org> <Pine.LNX.4.64.0702061615480.8424@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702061615480.8424@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 7 Feb 2007, David Woodhouse wrote:
>> It isn't that far off, and we could improve it if we wanted to. In
>> _general_ it's quite good already.
> 
> I agree that it's close to hierarchical. But it's literally the exceptions 
> that get you.
> 
> Let me mention (again) USB_STORAGE and ATA.
> 
> They are not "under" SCSI. Making them do that would be insane.
> 
> But yes, you can do hierarchies by adding "pseudo-variables": as 
> mentioned several times, we could actually split CONFIG_SCSI into two 
> separate ones: CONFIG_SCSI that selects the core infrastructure, and 
> CONFIG_SCSI_DRIVER that actually controls the "hierarchical visibility". 
> 
> Then CONFIG_SCSI_DRIVER (and USB_STORAGE, and SATA) would just do a simple 
> 'select SCSI'. It would _not_ be hierarchical, and it would very much use 
> that same old "select", but it would possibly be a cleanup at least in the 
> sense that now CONFIG_SCSI wouldn't be used two different ways (one to 
> hide most SCSI drivers, and one to enable the core SCSI infrastructure 
> code).
> 
>> It would work quite nicely in the graphical tools, although you've
>> thrown me a little by wanting it in the hacker's tool 'oldconfig' too.
>> You obviously care more about turning stuff _on_ with 'make oldconfig'
>> while other people who've spoken up seem to care more, as I do, about
>> turning stuff _off_ that way. If I want my hand held, I'm happy enough
>> to use the graphical tools.
> 
> I tend to just edit the .config file, and run "make oldconfig". And I know 
> I'm not the only one, because I've talked to others who do the same.
> 
> And yes, then it's almost always correct to "turn things on as needed to 
> make everything work out right", while turning things off would be 
> actively wrong.

That seems odd to me.  I usually use edit + oldconfig to disable a
symbol.  Maybe to enable a symbol occasionally.  But the symbols
that I want to enable usually aren't listed in .config at all,
so I end up using another config tool to enable them.
E.g., a sound driver when SOUND is completely disabled.

-- 
~Randy

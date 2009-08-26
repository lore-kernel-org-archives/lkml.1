Return-Path: <linux-kernel-owner+w=401wt.eu-S1756390AbZHZAiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbZHZAiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290AbZHZAiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:38:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36422 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbZHZAiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:38:12 -0400
Date: Wed, 26 Aug 2009 02:38:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: david@lang.hm, Theodore Tso <tytso@mit.edu>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] document flash/RAID dangers
Message-ID: <20090826003803.GP4300@elf.ucw.cz>
References: <20090825222112.GB4300@elf.ucw.cz> <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm> <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm> <20090825233701.GH4300@elf.ucw.cz> <4A947839.4010601@redhat.com> <20090826000657.GK4300@elf.ucw.cz> <4A947E05.8070406@redhat.com> <20090826002045.GO4300@elf.ucw.cz> <4A9481BE.1030308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9481BE.1030308@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> I'm not sure what's rare about power failures. Unlike single sector
>>>> errors, my machine actually has a button that produces exactly that
>>>> event. Running degraded raid5 arrays for extended periods may be
>>>> slightly unusual configuration, but I suspect people should just do
>>>> that for testing. (And from the discussion, people seem to think that
>>>> degraded raid5 is equivalent to raid0).
>>>
>>> Power failures after a full drive failure with a split write during a rebuild?
>>
>> Look, I don't need full drive failure for this to happen. I can just
>> remove one disk from array. I don't need power failure, I can just
>> press the power button. I don't even need to rebuild anything, I can
>> just write to degraded array.
>>
>> Given that all events are under my control, statistics make little
>> sense here.
>
> You are deliberately causing a double failure - pressing the power button 
> after pulling a drive is exactly that scenario.

Exactly. And now I'm trying to get that documented, so that people
don't do it and still expect their fs to be consistent.

> Pull your single (non-MD5) disk out while writing (hot unplug from the 
> S-ATA side, leaving power on) and run some tests to verify your 
> assertions...

I actually did that some time ago with pulling SATA disk (I actually
pulled both SATA *and* power -- that was the way hotplug envelope
worked; that's more harsh test than what you suggest, so that should
be ok). Write test was fsync heavy, with logging to separate drive,
checking that all the data where fsync succeeded are indeed
accessible. I uncovered few bugs in ext* that jack fixed, I uncovered
some libata weirdness that is not yet fixed AFAIK, but with all the
patches applied I could not break that single SATA disk.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

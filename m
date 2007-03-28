Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbXC1VTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbXC1VTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 17:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbXC1VTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 17:19:14 -0400
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.210]:41860 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753071AbXC1VTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 17:19:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GPdETbnjKzxG6Qa7z71I8HmZa/GAEDMprs4GIR0xqI2K37kZX9ic20A6JA9dDhRlxcNZB0ecM4V4JtNRR3Vaj8Susskt5Q7TIVme1TY3Q28klgYQY83Gk4G6DoHcxtpL8+KXqCZrE64MnUhbgUtYxC16EWLYIT8r0UjQIKfJJnI=  ;
X-YMail-OSG: BcRs0NIVM1mofcEiDtmIkd8l3Y5mC2ZTeQkdgBp3blF8SwNsFwNOiT5fyGZc7H3ceGRO0GayqQ--
From: David Brownell <david-b@pacbell.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [linux-pm] [3/6] 2.6.21-rc4: known regressions
Date: Wed, 28 Mar 2007 14:17:36 -0700
User-Agent: KMail/1.7.1
Cc: linux-pm@lists.linux-foundation.org, Maxim <maximlevitsky@gmail.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>, linux-ide@vger.kernel.org,
       gregkh@suse.de, linux-pm@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, linux-acpi@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, jgarzik@pobox.com,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703281238.57811.david-b@pacbell.net> <Pine.LNX.4.64.0703281336280.6730@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703281336280.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703281417.38655.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2007 1:42 pm, Linus Torvalds wrote:
> 
> I won't disagree - it might well be much nicer to just show it in the 
> "real" device tree. I'm not 100% sure where in the tree it would go, 
> though. It should probably be "inside" the root entry, before any of the 
> PCI buses. 

Mixing "inside" and "before" is a small linguistic clue about
one of the issues with driver model PM.  Off topic here; and
in terms of suspend/resume callback sequencing that answer
shouldn't matter much for HPET (as I understand things).


> It's generally what we've used those "system device" things  
> for, but I agree that it would be better to just make system devices show 
> up early on the regular device list than it is to have them be special 
> cases.

Yes -- where "platform_device" is a regular Joe-Sixpack kind of
device, but "sysdev" is a special case.


> Bit I think that's a separate (and fairly small) issue compared to the 
> "don't use the clocksource infrastructure as a make-believe suspend/resume 
> mechanism" problem that Maxim's patch had.

Agreed -- although isn't it the "clockevent" change which is at issue?

A "clockevent" thingie wraps various kinds of timer IRQs; the clocksource
is conceptually just a free run counter.  Clocksources have been around
for a while, with no particular problems.

It's clockevent sources have been the problem with dynamic tick solutions
all along, since they mask such chaos inside x86 hardware and interact
with so many different parts of the kernel.  ;)

- Dave


> (Maxim, don't take that the wrong way - I think your analysis and patch 
> were great, I just think another organization would be better)

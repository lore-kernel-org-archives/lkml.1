Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbXG1SUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbXG1SUt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 14:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbXG1SUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 14:20:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45721 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbXG1SUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 14:20:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: CONFIG_SUSPEND? (was: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1)
Date: Sat, 28 Jul 2007 20:29:02 +0200
User-Agent: KMail/1.9.5
Cc: Len Brown <lenb@kernel.org>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <200707251238.50218.lenb@kernel.org> <alpine.LFD.0.999.0707280921150.3442@woody.linux-foundation.org> <alpine.LFD.0.999.0707280932470.3442@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707280932470.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707282029.03563.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 28 July 2007 18:55, Linus Torvalds wrote:
> 
> On Sat, 28 Jul 2007, Linus Torvalds wrote:
> > 
> > And it's the *top*level* code that selects HOTPLUG_CPU. Through 
> > SUSPEND_SMP (which will select HOTPLUG_CPU) and SOFTWARE_SUSPEND.
> 
> In other words, the problem seems to be that 
> 
> 	kernel/power/main.c:
> 		suspend_devices_and_enter()
> 
> does the proper "disable/enable_nonboot_cpus()", but it does so without 
> having enabled CPU hotplug.
> 
> And you seem to think that it's ACPI that should enable the hotplug, even 
> though the code that actually needs it is _outside_ ACPI. And I think 
> that's wrong, and that this is a bug.
> 
> So I think the real issue is that we allow that 
> "suspend_devices_and_enter()" code to be compiled without HOTPLUG_CPU in 
> the first place. It's not supposed to work that way.
> 
> Of course, it may well be that other architectures can happily suspend 
> even with multiple CPU's active, which may be the cause of this mess. But 
> I really think it shouldn't be ACPI that has to select the CPU hotplug, 
> since it's not ACPI that _uses_ it in the first place.
> 
> Rafael: making a config option for STR (the same way we have a config 
> option for hibernate), and just not allowing it on SMP without HOTPLUG_CPU 
> seems to be the right thing. Len is right in that we do insane things 
> right now (trying to STR with multiple CPU's still active), and I just 
> don't think he's the one that should work around it!

Well, I agree and that's why I asked. :-)

OK, I'll prepare a patch to introduce CONFIG_SUSPEND, but that will require
quite a bit of (compilation) testing on different architectures.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

Return-Path: <linux-kernel-owner+w=401wt.eu-S933083AbXF2Ml5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083AbXF2Ml5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbXF2Mlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:41:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55192 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbXF2Mlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:41:49 -0400
Date: Fri, 29 Jun 2007 14:36:41 +0200
From: Stefan Seyfried <seife@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       linux-kernel@vger.kernel.org, suspend-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>, fseidel@suse.de
Subject: Re: [RFC] get rid of CONFIG_DISABLE_CONSOLE_SUSPEND
Message-ID: <20070629123641.GA7887@suse.de>
References: <20070628135108.GA1810@elf.ucw.cz> <200706281734.54642.rjw@sisk.pl> <20070628172514.GA12770@suse.de> <200706282112.45378.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706282112.45378.rjw@sisk.pl>
X-Operating-System: openSUSE 10.3 (i586) Alpha5, Kernel 2.6.22-rc4-git6-2-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 09:12:44PM +0200, Rafael J. Wysocki wrote:
> On Thursday, 28 June 2007 19:25, Stefan Seyfried wrote:
> > 
> > However, we don't know which consoles are safe to stay alive during suspend.
> > Generally, defaulting to suspending them all is not a bad idea IMHO.
> > And IIRC it is plain luck if a serial console survives the suspend (or was
> > the serial code fixed recently?)
> 
> Well, I don't think so, but I'm not sure.
> 
> The VGA/fb console also should be off during suspend (not necessarily during
> hibernation, though).  IIRC, that's what caused Linus to introduce the
> suspending of consoles after all.
> 
> > So i do not care too much, but my / Frank's patch was shorter :-) and safer.
> 
> I'm not sure which way to go.  On the one hand, I agree that we should rather
> fix the consoles so that we know which one is suspend-safe and which is not
> and disable the unsafe ones, but on the other hand we are not there yet and it
> _sometimes_ is useful not to suspend a console even if we know that it will
> break things.

This is what my / Frank's patch was aimed at: give the user the ability to
(painlessly, without rebuilding the kernel) debug suspend problems. Keep the
default safe, like Linus likes it (consoles suspended), but give the user a
switch to make it unsafe (consoles not suspended) for the sake of debugging.

Of course, fixing up all console drivers is an option that i'd very much like
to see. It is however debatable if it is really worth the effort. If it works
with consoles suspended, the user does not care. If it doesn't, he turns on
debugging (knowing, or being told that this will break using netconsole).

I strongly oppose Pavel's approach to "declare all console drivers as
nonbroken except netconsole". Even if he has not seen any failures apart
from netconsole, in general i had the impression that suspending consoles
did help. At least suspend works on many more machines than half a year ago,
and i'd not be surprised if this was partly due to suspending the consoles.

Remember that wrt. suspend "i did not get a bugreport" very often just means
"people tried it, it did not work, but they expected that and just turned
 away". It does not mean "it just works for everyone".
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)

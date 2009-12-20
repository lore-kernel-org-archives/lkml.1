Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbZLTTYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbZLTTYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 14:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbZLTTYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 14:24:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37494 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445AbZLTTYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 14:24:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Async suspend-resume patch w/ completions (was: Re: 
 =?iso-8859-1?q?Async=09suspend-resume_patch_w/?= rwsems)
Date: Sun, 20 Dec 2009 20:25:25 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <alpine.LFD.2.00.0912191557320.3712@localhost.localdomain> <20091220024142.GC4073@core.coreip.homeip.net>
In-Reply-To: <20091220024142.GC4073@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912202025.25618.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 December 2009, Dmitry Torokhov wrote:
> On Sat, Dec 19, 2009 at 04:09:07PM -0800, Linus Torvalds wrote:
> > 
> > That said, I still get the feeling that we'd be even better off simply 
> > trying to avoid the whole keyboard reset entirely. Apparently we do it for 
> > a few HP laptops.
> 
> I was mistaken, HP laptops do not like mouse disabled when suspending,
> not sure about the rest of the state.
> 
> > It's entirely possible that we'd be better off simply 
> > not _doing_ the slow thing in the first place.
> >
> 
> The reset appeared first in 2.5.42. I expect that some BIOSes get very
> confused when tehy find mouse speaking something that they do not
> unserstand (i.e. synaptics, ALPS or anything else that is not bare PS/2
> or intellimouse), but maybe Vojtech remembers better?
>  
> > For example, we may be _much_ better off doing that whole keyboard reset 
> > at resume time than at suspend time.
> 
> We do the reset for the different reasons - at resume we want the device
> in known state to ensure that it properly responds to the probes we
> send to it. At suspend we trying to reset things into original state so
> that the firmware will not be confused.
> 
> If we want to try to live without reset we could to PSMOUSE_CMD_RESET_DIS
> instead of PSMOUSE_CMD_RESET_BAT which is much heavier. We should
> probably not wait for .34 then because the bulk of testing will happen
> only when .33 is close to be released because that's when most of
> regular users will start using the new code and try to suspend and
> resume.
> 
> Rafael, how long does suspend take if you change call to psmouse_reset()
> in psmouse_cleanup() to ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_RESET_DIS)?
> And do the same for atkbd...

On the nx6325 that appears to reduce the suspend time as much so the effect
of async is not visible any more.  On the Wind it decreases the total suspend
time almost by half!

Please push this patch to Linus. :-)

> BTW, making just serio asynchronous while keeping i8042 synchronous
> makes no sense because I serialize access to i8042 - the thing does not
> survive simultaneous [command] access to both keyboard and mouse...

OK

Rafael

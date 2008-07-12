Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbYGLXPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbYGLXPS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 19:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYGLXPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 19:15:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59910 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYGLXPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 19:15:03 -0400
Message-Id: <200807122307.m6CN7Le0031003@terminus.zytor.com>
MIME-Version: 1.0
content-class: 
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: RE: [RFT] x86 acpi: normalize segment descriptor register on resume
Date: Sat, 12 Jul 2008 16:07:29 -0700
Importance: normal
X-Priority: 3
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Andy Lutomirski <luto@myrealbox.com>
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       <kernel-testers-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems like a reasonable guess at least.  I won't have a chance to dig into the details until late this evening or tomorrow, depending on when I get home tonight.

-- 
Sent from my mobile phone (pardon any lack of formatting)


-----Original Message-----
From: Rafael J. Wysocki <rjw@sisk.pl>
Sent: Saturday, July 12, 2008 13:53
To: Andy Lutomirski <luto@myrealbox.com>; H. Peter Anvin <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>; Ingo Molnar <mingo@elte.hu>; kernel-testers-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; ACPI Devel Maling List <linux-acpi@vger.kernel.org>; LKML <linux-kernel@vger.kernel.org>; pm list <linux-pm@lists.linux-foundation.org>; Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume

On Saturday, 12 of July 2008, Andy Lutomirski wrote:
> Rafael J. Wysocki wrote:
> > On Saturday, 12 of July 2008, Andy Lutomirski wrote:
> >> My Lenovo X61s fails to resume if I suspend it from within X, on both 
> >> 2.6.26-rc9 and recent wireless-testing.  2.6.26-rc8 is fine, as is 
> >> wireless-testing with 4b4f7280 reverted.  My in-progress bisect between 
> >> -rc8 and -rc9 is also consistent with this being the problem.
> >>
> >> The symptom is that, when I push the power button to resume, the hard 
> >> drive light turns on, the fan turns on, then the hard drive light turns 
> >> off, the sleep light stays on, and the fan keeps running.  Sometimes the 
> >> battery light will blink off very briefly (1/4 sec, maybe) every few 
> >> seconds.  The system is locked hard at this point.
> >>
> >> I'm using Ubuntu Hardy userspace.
> > 
> > Well, that's bad.
> > 
> > There is the bugzilla entry at http://bugzilla.kernel.org/show_bug.cgi?id=11064
> > for this bug and you've just confirmed my suspicion that this particular
> > commit is to blame.
> > 
> > Can you please see if the appended patch changes anything?
> 
> More correctly:
> 
> If I suspend by typing pm-suspend or echo mem >/sys/power/state, then it 
> resumes just fine.  If I log in to Gnome and push the suspend button, 
> then it does not resume.  This seems to be the case with or without your 
> patch.

Is there an Intel graphics in your box?

> -rc8 and -rc9 with the original patch 4b4f7280 resume fine no matter how 
> I suspend.

That's _really_ strange.

In fact I have only one explanation, which is that the Gnome suspend button
causes some user-space quirks to be applied, which are harmful and break the
resume.  Also, without commit 4b4f7280 those quirks might have not been really
executed.  Peter, does it sound reasonable?

Thanks,
Rafael


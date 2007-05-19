Return-Path: <linux-kernel-owner+w=401wt.eu-S1764159AbXEST47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764159AbXEST47 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 15:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758710AbXEST4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 15:56:48 -0400
Received: from ns.suse.de ([195.135.220.2]:36724 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758623AbXEST4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 15:56:47 -0400
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Len Brown <lenb@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>, Chuck Ebbert <cebbert@redhat.com>,
       len.brown@intel.com, Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <200705171517.14087.lenb@kernel.org>
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	 <464B43BB.3070505@redhat.com> <20070517092318.GD3975@ucw.cz>
	 <200705171517.14087.lenb@kernel.org>
Content-Type: text/plain
Date: Sat, 19 May 2007 14:56:49 -0500
Message-Id: <1179604609.16465.83.camel@sublime.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 15:17 -0400, Len Brown wrote:
> On Thursday 17 May 2007 05:23, Pavel Machek wrote:
> 
> > >     ACPI: thermal trip points are read-only
> > 
> > What was the rationale? Can we get this one reverted? 
> > 
> > Some machines (HP omnibook xe3) have broken trip points -- too high --
> > so machine will overheat and trigger hw shutdown before starting
> > passive cooling.
> > 
> > That's really broken, and write to trip points is reasonable way to
> > 'fix' that. (I'd understand if you only ever let trip points to
> > decrease... but otoh root should be able to shoot himself....)
> 
> No, writing trip-points is neither a fix, nor it is reasonable.
> It is a workaround at best, and it is a dangerous and mis-leading hack.
Yes it is a workaround for critical ACPI bugs like that or similar:
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.17/+bug/22336

It's also convenient to e.g. lower passive trip point to avoid fan
noise.

Some people are used to it, I already wanted to write a little userspace
prog to use them as it is really easy to fake cooling_mode (trip points
are modified by BIOS) and eliminate fan noise and other things by e.g.
reducing passsive or whatever trip point.

This is at least a major sysfs interface change, has this been discussed
somewhere before or declared deprecated?

It's there for a long time, why is this "a dangerous and mis-leading
hack." now?

I'd suggest to revert this and I can come with something like "only
allow lower values
than BIOS provides" patch if the current implementation is considered
dangerous.

      Thomas

> The OS has no capability to actually change the ACPI trip points
> that are used by the BIOS.  Changing the OS copy of them
> to make the user think that trip events will actually
> happen when the temperature crosses the OS copy is crazy.
> 
> If there are systems with broken thermals and the
> ACPI thermal control needs and over-ride to turn
> on the fan, then that is fine -- but using
> fake trip-points and giving the user the impression
> that they are real is not viable.



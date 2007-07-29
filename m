Return-Path: <linux-kernel-owner+w=401wt.eu-S937147AbXG2WOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937147AbXG2WOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 18:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbXG2WO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 18:14:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49600 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908AbXG2WOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 18:14:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Richard Hughes <hughsient@gmail.com>
Subject: Re: [PATCH 2/2] Introduce CONFIG_SUSPEND
Date: Mon, 30 Jul 2007 00:22:53 +0200
User-Agent: KMail/1.9.5
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org> <200707292336.55588.rjw@sisk.pl> <1185744640.2295.4.camel@work>
In-Reply-To: <1185744640.2295.4.camel@work>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707300022.54633.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 July 2007 23:30, Richard Hughes wrote:
> On Sun, 2007-07-29 at 23:36 +0200, Rafael J. Wysocki wrote:
> > On Sunday, 29 July 2007 23:18, Adrian Bunk wrote:
> > > On Sun, Jul 29, 2007 at 11:17:20PM +0200, Rafael J. Wysocki wrote:
> > > > On Sunday, 29 July 2007 22:40, Adrian Bunk wrote:
> > > > > On Sun, Jul 29, 2007 at 02:38:05PM +0200, Rafael J. Wysocki wrote:
> > > > > >...
> > > > > > +config SUSPEND
> > > > > > +	bool "Suspend"
> > > > >              "Suspend to RAM"
> > > > 
> > > > Not only.  This also includes "standby".
> > > 
> > > Whatever it includes - please tell it to the user in the prompt.
> > > 
> > > Technical issues are important, but it's often forgotten how many 
> > > problems people run into because the description of a kconfig option 
> > > could have been better.
> > 
> > Sure.  Please see the updated patch I've just sent. :-)
> 
> So are you guys using:
> 
> "standby" = idle state, ~0.5 seconds
> "suspend" = sleep to ram, ~10 seconds
> "hibernate" = sleep to disk, ~30 seconds

Something like this, but "suspend" is not reserved as a name of specific state.

The second state is usually referred to as "suspend to RAM" or "STR" and is
denoted by "mem" in /sys/power/state, if implemented.  Moreover, "standby" and
"mem" are both entered using the same code path, so they may generally be
referred to as "suspend" states.

The times aren't strictly defined for "mem" and "standby", too.  The general
rule is that the times for "mem" are greater then for "standby" and the power
drawn in "mem" is smaller than the power drawn in "standby", but the exact
values will always depend on the platform.  Apart from this, if the platform
supports only one "suspend" state, it decides if that's "mem" or "standby".

On ACPI systems "standby" and "mem" correspond to the S1 and S3 sleep states,
respectively.

Greetings,
Rafael
 

-- 
"Premature optimization is the root of all evil." - Donald Knuth

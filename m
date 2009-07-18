Return-Path: <linux-kernel-owner+w=401wt.eu-S1758133AbZGRKiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbZGRKiH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 06:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbZGRKiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 06:38:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58306 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbZGRKiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 06:38:05 -0400
Date: Sat, 18 Jul 2009 12:37:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stephen Chen <Stephen.Chen@atheros.com>
Subject: Re: Generic events for wake up from S1-S4
Message-ID: <20090718103756.GA11381@elf.ucw.cz>
References: <43e72e890907141511h70a0a987g57cb26e23e5824a9@mail.gmail.com> <20090714235332.GA1552@ucw.cz> <43e72e890907150851m69cd2de6lfb71596fbfac30e6@mail.gmail.com> <43e72e890907151100j37feb30av7281d09960ca5db2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890907151100j37feb30av7281d09960ca5db2@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-07-15 11:00:07, Luis R. Rodriguez wrote:
> On Wed, Jul 15, 2009 at 8:51 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> > On Tue, Jul 14, 2009 at 4:53 PM, Pavel Machek<pavel@ucw.cz> wrote:
> >> On Tue 2009-07-14 15:11:45, Luis R. Rodriguez wrote:
> >>> I'm working on Wake-on-Wireless support for wireless right now [1].
> >>> Upon wake up I wanted to inform the kernel of the event which caused
> >>> the wake up but am not clear if there is a generic API for this. Mind
> >>> you, for WoW we'll need at least some AC power to the card so we'll
> >>> need to at least be in S3-Hot so we'll only need events for that for
> >>> now.
> >>>
> >>> Do we have some generic infrastructure to gather reasons for wake up
> >>> from S1-S4 and pass this to userspace yet?
> >>
> >> I do not think generic api exists...
> 
> Going back to this topic -- any suggestions? Will a generic netlink
> family be OK? Or perhaps easier a udev event for some suitable
> existing parent ?

Is "who woke me" information even relevant? Yes, it may be interesting
enough for printk, but... What will userspace do with that information?

Imagine WoW packet comes, 5msec later WoL packet comes, 5msec later
user opens the lid. You report WoW as wakeup reason, but it is
inherently "racy".

What about simply reporting "wake event happened on this device" and
doing that for all the devices?


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

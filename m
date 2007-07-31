Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbXGaJwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbXGaJwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 05:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbXGaJwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 05:52:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57014 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbXGaJwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 05:52:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-pm] Re: [PATCH 2/2] Introduce CONFIG_SUSPEND (updated)
Date: Tue, 31 Jul 2007 12:01:07 +0200
User-Agent: KMail/1.9.5
Cc: linux-pm@lists.linux-foundation.org, Len Brown <lenb@kernel.org>,
       david@lang.hm, Nigel Cunningham <nigel@nigel.suspend2.net>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>,
       linux-acpi@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org> <200707311115.29057.rjw@sisk.pl> <200707311116.39857.oliver@neukum.org>
In-Reply-To: <200707311116.39857.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311201.09384.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 31 July 2007 11:16, Oliver Neukum wrote:
> Am Dienstag 31 Juli 2007 schrieb Rafael J. Wysocki:
> 
> > Well, the people on linux-pm seem to agree that the .suspend() and .resume()
> > callbacks are not suitable for runtime power management, so having them
> > built without SUSPEND or HIBERNATION wouldn't be very useful. ;-)
> 
> These are what USB runtime power management uses.

To be precise, I think the rule should be that if some code is needed for
anything else than suspend/hibernation, it should be under plain CONFIG_PM.
Still, if something is only needed for suspend/hibernation, it should go under
CONFIG_PM_SLEEP or CONFIG_SUSPEND/HIBERNATION, depending on what it's needed
for.

Now, AFAICS, for the majority of drivers .suspend() and .resume() are only
needed for suspend/hibernation and really should be used for suspending
only (some other callbacks are needed for hibernation).

> How many code paths for power management do you want to introduce?

At least one more, for hibernation.

That also depends on what approach to the runtime power management is widely
accepted.  For now, USB is in the vanguard. :-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbZGAXGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbZGAXGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 19:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZGAXGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 19:06:17 -0400
Received: from deleuze.hcoop.net ([69.90.123.67]:34358 "EHLO deleuze.hcoop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbZGAXGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 19:06:17 -0400
From: Jeremy Maitin-Shepard <jeremy@jeremyms.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] RFC: Suspend-to-ram cold boot protection by encrypting page cache
References: <87hbxx0wcp.fsf@jeremyms.com> <200907011755.10386.rjw@sisk.pl>
	<874otw15r6.fsf@jeremyms.com> <200907020041.52198.rjw@sisk.pl>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Wed, 01 Jul 2009 16:06:00 -0700
In-Reply-To: <200907020041.52198.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Thu, 02 Jul 2009 00:41:51 +0200")
Message-ID: <87r5x0ypev.fsf@jeremyms.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> [snip]

> What is the particular attach scenario you'd like to prevent

The standard cold boot attack, which basically allows the attacker to
obtain a copy of the data in RAM.  System is powered on.  RAM is
optionally cooled.  RAM is then quickly removed from the original
machine, placed in another machine, and copied.  See
http://en.wikipedia.org/wiki/Cold_boot_attack

The wikipedia page links to this Youtube video that nicely demonstrates
the attack:

http://www.youtube.com/watch?v=JDaicPIgn9U

The cooling helps to preserve the data for longer, but is not always
even necessary.  Special hardware is not even needed.  Depending on
whether the BIOS clears the memory during the POST, it might also be
possible to do the attack on the same machine (i.e. without having to
move the RAM into another machine) by rebooting it and booting from
e.g. a CD-ROM or USB drive.

> [snip]

> There's one problem with this approach, which is that we're not sure if the
> encrypted pages won't be written to by someone else.  TuxOnIce makes the
> assumption that it won't, but that has yet to be demonstrated.

Yes, it certainly depends on that assumptions, but it is not necessarily
a problem that it does.

There are really two parts to that assumption:

1. Whether the current Linux kernel in a particular (or perhaps any)
   configuration _does_ satisfy that assumption.

2. Whether Linux _should_ satisfy that assumption.  This is important
   because if something comes along later that violates the assumption,
   it would be nice to be able to consider that something a bug and fix
   it.

It is really the second part that is most important, though evaluating
the extent to which the first part holds would help in determining the
feasibility of the second part.

-- 
Jeremy Maitin-Shepard

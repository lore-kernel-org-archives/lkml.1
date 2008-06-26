Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbYFZPM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbYFZPM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761027AbYFZPMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:12:25 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4753 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760472AbYFZPMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:12:23 -0400
Date: Thu, 26 Jun 2008 17:09:10 +0200
From: Pavel Machek <pavel@suse.cz>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Kyle Moffett <mrmacman_g4@mac.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: freeze vs freezer
Message-ID: <20080626150910.GK5642@ucw.cz>
References: <4744FD87.7010301@goop.org> <200711262253.35420.rjw@sisk.pl> <20071127053846.GA28884@srcf.ucam.org> <200711271840.24825.rjw@sisk.pl> <8B00F353-983F-40E7-931B-EA73CCD32F0A@mac.com> <20080623071601.GA1553@elf.ucw.cz> <20080623140012.GA11899@khazad-dum.debian.net> <87od5rs1am.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87od5rs1am.fsf@denkblock.local>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Patch would be welcome, actually. It turns out blocking new
> >> IO-requests is not completely trivial.
> 
> Quite. But I'm not sure I see what this is all about yet. From the IDE
> and SCSI subsystems I remember that they block all I/O from higher levels
> once the suspend callbacks have been executed. I haven't made an effort
> to understand the freezer (or indeed anything related to hibernation)
> yet since I don't even use hibernation myself (only s2ram). Do you have

s2ram also uses freezer these days. Difference is s2ram does not
really need it.

> any suggestion where to start reading up on things so I can get an idea
> what the issues are and what you would like IDE / SCSI / ... to do?

I'd like block layer to block any process that tries to do I/O.

> > Is this the same thing the per-device IO-queue-freeze patches for
> >HDAPS also
> > need to do?  If so, you may want to talk to Elias Oltmanns
> > <eo@nebensachen.de> about it.  Added to CC.
> 
> Thanks for the heads up Henrique. Even though these issues seem to be
> related up to a certain degree, there probably are some important
> differences. When suspending a system, the emphasis is on leaving the
> system in a consistent state (think of journalled file systems), whereas
> disk shock protection is mainly concerned with stopping I/O as soon as
> possible. As yet, I cannot possibly say to what extend these two
> concepts can be reconciled in the sense of sharing some common code.

Actually, I believe requirements are same.

'don't do i/o in dangerous period'.

swsusp will just do sync() before entering dangerous period. That
provides consistent-enough state...
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

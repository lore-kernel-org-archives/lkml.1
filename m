Return-Path: <linux-kernel-owner+w=401wt.eu-S1756324AbZLIR5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbZLIR5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbZLIR5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:57:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754136AbZLIR5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:57:23 -0500
Date: Wed, 9 Dec 2009 09:57:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <20091209174537.GJ9018@sirena.org.uk>
Message-ID: <alpine.LFD.2.00.0912090953200.3560@localhost.localdomain>
References: <20091209160256.GA3229@rakim.wolfsonmicro.main> <Pine.LNX.4.44L0.0912091117080.4120-100000@iolanthe.rowland.org> <20091209164653.GI9018@sirena.org.uk> <alpine.LFD.2.00.0912090851540.3560@localhost.localdomain>
 <20091209174537.GJ9018@sirena.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Dec 2009, Mark Brown wrote:
> 
> The problem comes when you've got audio outputs referenced to something
> other than ground which used to happen because no negative supplies were
> available in these systems.  To bring these up from cold you need to
> bring the outputs up to the reference level but if you do that by just
> turning on the power you get an audible (often loud) noise in the output
> from the square(ish) waveform that results which users don't find
> acceptable.

Ouch. A second still sounds way too long - but whatever.

However, it sounds like the nice way to do that isn't by doing it 
synchronously in the suspend/resume code itself, but simply ramping it 
down (and up) from a timer. It would be asynchronous, but not because the 
suspend itself is in any way asynchronous.

Done right, it might even result in a nice volume fade of the sound (ie if 
the hw allows for it, stop the actual sound engine late on suspend, and 
start it early on resume, so that sound works _while_ the whole reference 
volume rampdown/up is going on)

			Linus

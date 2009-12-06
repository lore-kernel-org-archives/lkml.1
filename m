Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbZLFB4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbZLFB4v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 20:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757167AbZLFB4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 20:56:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:47270 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136AbZLFB4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 20:56:44 -0500
Date: Sat, 5 Dec 2009 17:58:52 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [GIT PULL] PM updates for 2.6.33
Message-ID: <20091205175852.2500cdad@infradead.org>
In-Reply-To: <200912060226.06217.rjw@sisk.pl>
References: <200912052216.19540.rjw@sisk.pl>
	<200912060055.36130.rjw@sisk.pl>
	<20091205164541.5e0f209a@infradead.org>
	<200912060226.06217.rjw@sisk.pl>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Dec 2009 02:26:06 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday 06 December 2009, Arjan van de Ven wrote:
> > On Sun, 6 Dec 2009 00:55:36 +0100
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > 
> > > Disk spinup/spindown takes time, but also some ACPI devices resume
> > > slowly, serio devices do that too and there are surprisingly many
> > > drivers that wait (using msleep() during suspend and resume).
> > > Apart from this, every PCI device going from D0 to D3 during
> > > suspend and from D3 to D0 during resume requires us to sleep for
> > > 10 ms (the sleeping is done by the PCI core, so the drivers don't
> > > even realize its there).
> > 
> > maybe a good step is to make a scripts/bootgraph.pl equivalent for
> > suspend/resume (or make a debug mode that outputs in a compatible
> > format so that the script can be used as is.. I don't mind either
> > way, and consider this my offer to help with such a script as long
> > as there's sufficient logging in dmesg ;-)
> 
> OK, so what kind of logging is needed?

basically the equivalent of the two initcall_debug paths in

init/main.c:do_one_initcall()

which prints a start time and an end time (and a pid) for each init
function; if we have the same for suspend calls (and resume)... we can
make the tool graph it.
Would be nice to get markers for start and end of the whole suspend
sequence as well as for the resume sequence; those make it easier to
know when the end is (so that the axis can be drawn etc)

shouldn't be too hard to implement...



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

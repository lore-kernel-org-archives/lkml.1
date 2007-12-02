Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbXLBAOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbXLBAOp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 19:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbXLBAOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 19:14:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38358 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbXLBAOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 19:14:34 -0500
Date: Sat, 1 Dec 2007 16:13:02 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Mark Lord <lkml@rtr.ca>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, abelay@novell.com,
       lenb@kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 20000+ wake-ups/second in 2.6.24.   Bug?
Message-ID: <20071201161302.731b80d3@laptopd505.fenrus.org>
In-Reply-To: <4751F484.6040204@rtr.ca>
References: <200711302153.lAULrZ7n026255@imap1.linux-foundation.org>
	<924EFEDD5F540B4284297C4DC59F3DEE2FAE6A@orsmsx423.amr.corp.intel.com>
	<20071130142058.816d1693.akpm@linux-foundation.org>
	<924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com>
	<4750CC78.9070105@rtr.ca>
	<20071130190227.1976e682@laptopd505.fenrus.org>
	<4750D180.6080001@rtr.ca>
	<20071130191816.3e744205@laptopd505.fenrus.org>
	<4750D585.1030200@rtr.ca>
	<4750D899.4020905@rtr.ca>
	<4751F1AB.2060801@rtr.ca>
	<20071201154646.5a288c9e@laptopd505.fenrus.org>
	<4751F484.6040204@rtr.ca>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Dec 2007 18:55:48 -0500
Mark Lord <lkml@rtr.ca> wrote:

> Arjan van de Ven wrote:
> > On Sat, 01 Dec 2007 18:43:39 -0500
> > Mark Lord <lkml@rtr.ca> wrote:
> > 
> >> Dagnabbit.. it's done it again.. went from 100-200 wakeups/sec
> >> back up to 20000+ wakeups/sec.  This time *with* the powertop
> >> patches in place.
> >>
> >> Somethings broken in there, but I don't know what.
> >> Or how to make it happen on demand.. it's fine after rebooting
> >> again.
> >>
> >> ???
> >>
> >> At least now I know to look when I hear the fan turning on
> >> when the system is otherwise supposed to be idle..
> >>
> >> 2.6.23 did not have this problem.
> > 
> > actually we have reports of 2.6.23 having the exact same problem.
> > The thing is, "something" is causing the system to go into a state
> > where the cpu throws us right out of the C-state the kernel asks
> > for.
> ...
> 
> Ahh.  Okay, this machine here did not have the problem on 2.6.23.
> 
> > Some people have seen that not loading yenta at all will just make
> > this not happen at all...
> ...
> 
> No yenta/cardbus here -- it's all PCIe.

but.. is yenta loaded or built into the kernel?
or is the config option off?
Also, do you have a TI firewire bridge?
(just asking the common patterns we've sort of kinda seen so far)

> If you have any debug patches that could detect or help next time I
> see it, then feel free to toss them this way.

one thing to try (just as data collection) is to do 
lspci -vvxxx 
before it happens, and then again after it happens
and then diff to see if something changed ;(

(yes this is very crude; we've not been able to chase this one down at
all so far).
-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

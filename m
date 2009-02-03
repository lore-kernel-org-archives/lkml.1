Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbZBCAaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbZBCAaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbZBCA35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:29:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754119AbZBCA35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:29:57 -0500
Date: Mon, 2 Feb 2009 16:28:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: PCI PM: Restore standard config registers of all devices early
In-Reply-To: <200902030115.32659.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0902021622350.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902030045.19416.rjw@sisk.pl> <alpine.LFD.2.00.0902021551050.3247@localhost.localdomain> <200902030115.32659.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Rafael J. Wysocki wrote:
> 
> BTW, on the PMAC the problematic driver appears to be the radeon driver,
> according to Ben, and the breakage is not related to USB.

Hmm. atyfb_base.c has the same kind of things with magic PMAC code, but it 
doesn't follow the USB pattern - it just replaces "pci_set_power_state()" 
_entirely_. 

It seems a very interesting suspend routine, btw. It doesn't seem to do 
any of the pci_save_state() at all, just re-initializes from scratch. 
Maybe it is unhappy with the PM layer deciding to try to restore state 
since it clearly didn't..

		Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbYKJI2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbYKJI2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 03:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYKJI2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 03:28:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56171 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbYKJI2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 03:28:40 -0500
Date: Mon, 10 Nov 2008 09:28:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CONFIG_NUMA breaks hibernation on x86-32 with PAE
Message-ID: <20081110082802.GA22392@elte.hu>
References: <20081109140726.GB1786@ucw.cz> <20081110075216.GD2093@elte.hu> <20081110075529.GD707@atrey.karlin.mff.cuni.cz> <20081110172407.5584156d.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110172407.5584156d.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Mon, 10 Nov 2008 08:55:29 +0100
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > > 
> > > * Pavel Machek <pavel@suse.cz> wrote:
> > > 
> > > > ...at least on 2.6.27 and 2.6.28-rc3. Resume gets to 
> > > > acpi_hibernation_leave, then SLAB corruption is detected and machine 
> > > > ends in series of oops.
> > > > 
> > > > Any ideas how to debug that?
> > > 
> > > do you get any serial log or USB key output, so that it's debuggable 
> > > directly?
> > 
> > Well, I can transcribe the BUG() from a picture, I guess, but it does
> > not seem to contain much useful info: SLAB corruption was detected and
> > backtrace is not quite important at that point...
> > 
> > Serial console is probably possible, but would take few days to setup.
> > 									Pavel
> 
> How about this patch ?
> ==
> http://marc.info/?l=linux-mm-commits&m=122624388629106&w=2
> ==

note, that fix of Rafael's is now upstream as:

  c5d7124: Fix __pfn_to_page(pfn) for CONFIG_DISCONTIGMEM=y

and included in v2.6.28-rc4.

But yes, this area of code (the save/restore of memory maps) would be 
the main suspect to investigate.

	Ingo

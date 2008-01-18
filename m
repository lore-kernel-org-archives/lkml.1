Return-Path: <linux-kernel-owner+w=401wt.eu-S1758446AbYARATy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbYARATy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756016AbYARATp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:19:45 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756008AbYARATo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:19:44 -0500
Date: Thu, 17 Jan 2008 16:18:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, bunk@kernel.org, Dave Kleikamp <shaggy@austin.ibm.com>,
       Takashi Iwai <tiwai@suse.de>, Shaohua Li <shaohua.li@intel.com>,
       Jay Vosburgh <fubar@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: 2.6.24-rc8-git1: Reported regressions from 2.6.23
In-Reply-To: <20080117155809.7ebc3bb7.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0801171606300.2957@woody.linux-foundation.org>
References: <200801180035.42878.rjw@sisk.pl> <20080117155809.7ebc3bb7.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jan 2008, Andrew Morton wrote:
> 
> There are thirteen regressions for which we have patches but they aren't
> merged.  That seems rather high.

I think a number of them have been merged, or the thing that caused them 
reverted. For example.

> > Subject		: [2.6.24-rc6] pdflush still stuck in D state regression
> > Submitter	: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
> > Date		: 2007-11-02 09:54
> > References	: http://bugzilla.kernel.org/show_bug.cgi?id=9291
> > Handled-By	: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> > Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14219&action=view

Isn't this the same write-back-related thing, reverted by 
c23f72cae9523d29ff94eec8f30ccbdaf234b20e?

> > Subject		: snd_hda_intel 2.6.24-rc2 bug: interrupts don't always work on Lenovo X60s
> > Submitter	: Roland Dreier <rdreier@cisco.com>
> > Date		: 2007-11-08 14:55
> > References	: http://lkml.org/lkml/2007/11/8/255
> > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9332
> > Handled-By	: Takashi Iwai <tiwai@suse.de>
> > 		  Ingo Molnar <mingo@elte.hu>
> > Patch		: http://lkml.org/lkml/2007/11/16/66

This patch went in, but was reverted because it caused more problems than 
it fixed. And what it "fixed" was somewhat dubious anyway.

> > Subject	: jiffies counter leaps in 2.6.24-rc3
> > Submitter	: Stefano Brivio <stefano.brivio@polimi.it>
> > Date	: 2007-11-29 08:36
> > References	: http://lkml.org/lkml/2007/11/24/53
> > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9475
> > Handled-By	: Ingo Molnar <mingo@elte.hu>
> > Patch	: http://lkml.org/lkml/2007/12/7/132

I think this is just the printk timestamp, no? And I think Ingo fixed it 
differently.

> > Subject	: PATA_HPT37X embezzles two ports
> > Submitter	: "Bjoern Olausson" <lkmlist@gmail.com>
> > Date	: 2007-12-12 11:05
> > References	: http://lkml.org/lkml/2007/12/12/161
> > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9551
> > Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > Patch	: http://lkml.org/lkml/2007/1/4/161

Fixed by commit 73946f9fc5be1433f1e182d11303188390ff242f, afaik.

			Linus

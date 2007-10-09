Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbXJIXWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbXJIXWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 19:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbXJIXWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 19:22:35 -0400
Received: from www.tglx.de ([62.245.132.106]:37203 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbXJIXWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 19:22:34 -0400
Date: Wed, 10 Oct 2007 01:21:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <greg@kroah.com>
cc: Olof Johansson <olof@lixom.net>, Greg KH <gregkh@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>, Mark Lord <mlord@pobox.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 09/12] Fix SMP poweroff hangs
In-Reply-To: <20071009222003.GA21228@kroah.com>
Message-ID: <alpine.LFD.0.9999.0710100120340.7766@localhost.localdomain>
References: <20071008180406.052382073@mini.kroah.org> <20071008180633.GJ7627@kroah.com> <20071009151702.GA19209@lixom.net> <20071009222003.GA21228@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Oct 2007, Greg KH wrote:

> On Tue, Oct 09, 2007 at 10:17:02AM -0500, Olof Johansson wrote:
> > On Mon, Oct 08, 2007 at 11:06:33AM -0700, Greg KH wrote:
> > > From: Mark Lord <lkml@rtr.ca>
> > > 
> > > commit 4047727e5ae33f9b8d2b7766d1994ea6e5ec2991 from upstream
> > > 
> > > We need to disable all CPUs other than the boot CPU (usually 0) before
> > > attempting to power-off modern SMP machines.  This fixes the
> > > hang-on-poweroff issue on my MythTV SMP box, and also on Thomas Gleixner's
> > > new toybox.
> > 
> > Paul Mackerras has reported crashes when rebooting some older ppc64
> > systems due to this patch.
> > 
> > See http://ozlabs.org/pipermail/linuxppc-dev/2007-October/043969.html.
> 
> Has anything been done in mainline to possibly fix this?
> 
> If not, I think we'll leave it in, as it does solve a number of reported
> problems.

Wrapping it into a #ifdef CONFIG_X86 would be sufficient.

	tglx


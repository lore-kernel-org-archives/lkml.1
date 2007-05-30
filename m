Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbXE3PmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbXE3PmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbXE3Plx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:41:53 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:19647 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbXE3Plw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:41:52 -0400
Date: Wed, 30 May 2007 08:43:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Romano Giannetti <romanol@upcomillas.es>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
Message-Id: <20070530084347.e647a03e.randy.dunlap@oracle.com>
In-Reply-To: <1180520817.16962.8.camel@localhost>
References: <1180008394.15600.26.camel@localhost>
	<alpine.LFD.0.98.0705270924310.26602@woody.linux-foundation.org>
	<20070527164300.GA20355@srcf.ucam.org>
	<200705272032.15971.rjw@sisk.pl>
	<20070527184402.GA21161@srcf.ucam.org>
	<1180427492.21686.9.camel@localhost>
	<alpine.LFD.0.98.0705290752190.26602@woody.linux-foundation.org>
	<1180520817.16962.8.camel@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 12:26:57 +0200 Romano Giannetti wrote:

> 
> On Tue, 2007-05-29 at 07:55 -0700, Linus Torvalds wrote:
> > 
> > On Tue, 29 May 2007, Romano Giannetti wrote:
> > >
> > > - The good (?) news. I have made 7 suspend/resume cycle (to ram, I
> > > haven't tested hibernation) with a 2.6.21.2 with that patch, applied
> > > manually. The system did suspend and resume nicely even compiling a
> > > kernel and opening openoffice. Normally (le me stress _normally_) no
> > > delay was apparent on resume. I do not know how dangerous is this... :-)
> > > 
> > > - The bad (?) news. One time out of 7 I had the 60 seconds delay.
> > 
> > Interesting. If you can re-create it, please do the sysrq-T thing again, 
> > to see what's up. (Also, you might do "sysrq-p", which gives the current 
> > process data, which sysrq-T does not).
> 
> 
> I've got it, but I had a problem: I filled the dmesg buffer. I will try
> to find where to enlarge it. I have posted the partial result to: 

use 'dmesg -s 100000' if it's just dmesg(8) that needs help.
If it's the kernel buffer filling up, you can rebuild the kernel
after changing CONFIG_LOG_BUF_SHIFT, but it's easier just to boot
using this:
	log_buf_len=n	Sets the size of the printk ring buffer, in bytes.
			Format: { n | nk | nM }
			n must be a power of two.  The default size
			is set in the kernel config file.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbZBQXaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbZBQXaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbZBQX35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:29:57 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38618 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464AbZBQX34 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:29:56 -0500
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: "arjan@infradead.org" <arjan@infradead.org>
CC: mark gross <mgross@linux.intel.com>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arve Hj?nnev?g <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Uli Luckas <u.luckas@road.de>, Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Date: Tue, 17 Feb 2009 17:28:32 -0600
Subject: RE: [RFD] Automatic suspend
Thread-Topic: [RFD] Automatic suspend
Thread-Index: AcmRTcr3Bk3UP9fWSXKtuAZTS/blqwAB8Pdg
Message-ID: <13B9B4C6EF24D648824FF11BE8967162037726145B@dlee02.ent.ti.com>
References: <200902160010.16955.rjw@sisk.pl>
 <20090217215717.GA25605@linux.intel.com>
 <20090217220439.GA1573@srcf.ucam.org>
 <200902171419.14823.jbarnes@virtuousgeek.org>
In-Reply-To: <200902171419.14823.jbarnes@virtuousgeek.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Jesse Barnes [mailto:jbarnes@virtuousgeek.org]
> Sent: Tuesday, February 17, 2009 4:19 PM

> On Tuesday, February 17, 2009 2:04 pm Matthew Garrett wrote:
> > On Tue, Feb 17, 2009 at 01:57:17PM -0800, mark gross wrote:
> > > Putting the wake on key event issue aside, is it possible to have wake
> > > up's on the ms time scale?  I ask because I thought the XO did exactly
> > > this (but left the screen live).  Why does it take 20 sec to get into
> > > or out of S3 on my laptop?
> >
> > Graphics reinit, dumping graphics contents back into RAM, us resuming
> > devices in series, that kind of thing. On some hardware you'll spend a
> > noticable amount of time in the BIOS before any of the Linux resume code
> > gets touched. I thought the XO had got sub second, but I wasn't sure
> > that they were in the low ms range.
>
> IME a good chunk of it is BIOS time.  On my x200s resume is very fast (on the
> order of a second or two though I haven't measured), while on my Eee and T61
> machines it's much slower, even though they're all using Intel gfx.
>
> Of course we should really be shooting for sub-second times or about the time
> it takes you to open your lid (or even much faster in the case of demand
> suspend/resume for servers/desktops).

This is good example of embedded ARM time scales not matching up with x86 ones.  For OMAP3 our resumption from OFF mode (full SOC context lost) software budget was in the 10s of milliSeconds.  There is no BIOS and we must generate most of the code.

As such very frequent fast OFF mode transitions are useful and possible.  As I said in another part of the thread, the slow part is Voltage ramp time. Also clock setup time of external oscillator can be 5-10mS by itself.

This tight timing was the requirement of some modems which required a response ASAP when data was coming.  Not every modem is so tight but some are.

Regards,
Richard W.


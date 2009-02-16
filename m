Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbZBPWiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbZBPWiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 17:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbZBPWil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 17:38:41 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53314 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbZBPWil convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 17:38:41 -0500
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: Arjan van de Ven <arjan@infradead.org>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Date: Mon, 16 Feb 2009 16:36:43 -0600
Subject: RE: [RFD] Automatic suspend
Thread-Topic: [RFD] Automatic suspend
Thread-Index: AcmQgNNh0rnJaLOJS3+2X4+2ygxrqwAACmLA
Message-ID: <13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com>
	<Pine.LNX.4.44L0.0902161537080.19732-100000@netrider.rowland.org>
	<20090216124520.315320dc@infradead.org>
	<13B9B4C6EF24D648824FF11BE896716203771DCF1E@dlee02.ent.ti.com>
 <20090216135204.064f553b@infradead.org>
In-Reply-To: <20090216135204.064f553b@infradead.org>
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


> From: Arjan van de Ven [mailto:arjan@infradead.org]
> Sent: Monday, February 16, 2009 3:52 PM
> On Mon, 16 Feb 2009 15:32:06 -0600
> "Woodruff, Richard" <r-woodruff2@ti.com> wrote:
> >
> > - It provides a way to handle overdrive/turbo operating points out of
> > band from the generically tuned cpufreq governors like ondemand.  The
> > way we characterize overdrive is stricter then what Intel has talked
> > about for x86.
>
> if you have an improved-for-your-systems governor then I'm sure that is
> very welcome in the kernel.

No, the generic governors were not substantially improved. Not every customer is using cpufreq for DVFS. As such we went underneath it. If we had more community presence at the start time we might have also tried that.

> I think just about all of us agree that the final decision needs to be
> in the driver (possibly followed by something that gets various device
> requests and combines it into hw settings); we're just talking about
> what inputs feed into that decision ;)
>
> And for different types of devices that's guaranteed to be different...
> and sometimes we'll be hampered by existing interfaces, so we might end
> up with hacky stuff.

Is there some kind of roadmap which can be plotted which goes from course to more granular control?

Phase 1 (all or nothing): like wakelocks (minus back light): system-auto-suspend-on, system-auto-suspend-off.  The drivers can still veto as they do today.

Phase 2: Subsystem generic tunable, on say latency + bandwidth. Start with CPU then move to classes like USB.

Phase 3: ??? if needed add direct device control, hints on an extended fadvise(), and explicit control left to open/close and direct ioctls?

I don't know that 1,2,3 above even make sense.  However, the notion of actually plotting out a course with goals does as it will take a long time and it is good to get some benefit along the way.

Thanks,
Richard W.


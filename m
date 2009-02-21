Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbZBUUV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbZBUUV0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 15:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZBUUVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 15:21:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60664 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbZBUUVQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 15:21:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFD] Automatic suspend
Date: Sat, 21 Feb 2009 21:20:35 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <200902192215.18365.rjw@sisk.pl> <200902211047.26787.rjw@sisk.pl> <d6200be20902210232m71700247k8914ca3735563881@mail.gmail.com>
In-Reply-To: <d6200be20902210232m71700247k8914ca3735563881@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902212120.37684.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 February 2009, Arve Hjønnevåg wrote:
> On Sat, Feb 21, 2009 at 1:47 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday 21 February 2009, Arve Hjønnevåg wrote:
> >> On Fri, Feb 20, 2009 at 3:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Saturday 21 February 2009, Arve Hjønnevåg wrote:
> >> >> On Fri, Feb 20, 2009 at 7:56 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> >> > On Friday 20 February 2009, Arve Hjønnevåg wrote:
> >> >> >> On Fri, Feb 20, 2009 at 2:49 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> >> >> > On Friday 20 February 2009, Arve Hjønnevåg wrote:
> >> >> >> >> On Thu, Feb 19, 2009 at 2:08 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
[--snip--]
> >> > The idea is to have both /sys/power/state and /sys/power/sleep at the same
> >> > time, where /sys/power/state will work just like it does right now.  Sure,
> >> > there must be mutual exclusion between the two, but that's a matter of
> >> > implementation IMO.
> >>
> >> If you want to only prevent suspend though one interface, you have to
> >> also pass information to the driver about its suspend hook is being
> >> called so it can conditionally return -EBUSY. The wakelock interface
> >> requires less code in each driver.
> >
> > Well, I don't think so.  Moreover, it requires you to spread wakelocks all
> > over the place if you don't use the timeouted ones which, let's face it, is
> > hardly acceptable.
> 
> Your method does not reduce the number of places that has to be
> modified. Any component where we add a wakelock, you have to add a
> suspend handler to abort suspend when we would have held a wakelock.

Well, maybe not, but it doesn't introduce entirely new API for device drivers.
Instead, it extends the existing interfaces which I think is more appropriate.

Thanks,
Rafael

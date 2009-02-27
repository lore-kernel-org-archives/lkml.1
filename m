Return-Path: <linux-kernel-owner+w=401wt.eu-S1761066AbZB0Wzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761066AbZB0Wzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 17:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757527AbZB0Wzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 17:55:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46118 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871AbZB0Wzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 17:55:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFD] Automatic suspend
Date: Fri, 27 Feb 2009 23:55:10 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@ucw.cz>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <200902192215.18365.rjw@sisk.pl> <200902272154.03539.rjw@sisk.pl> <d6200be20902271409y395822c9ic8f1223f6551631c@mail.gmail.com>
In-Reply-To: <d6200be20902271409y395822c9ic8f1223f6551631c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902272355.12240.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 February 2009, Arve Hjønnevåg wrote:
> On Fri, Feb 27, 2009 at 12:54 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday 27 February 2009, Matthew Garrett wrote:
> >> On Fri, Feb 27, 2009 at 03:22:39PM +0100, Rafael J. Wysocki wrote:
> >> > On Friday 27 February 2009, Pavel Machek wrote:
> >> > > Wakelocks done right are single atomic_t... and if you set it to 0,
> >> > > you just unblock "sleeper" thread or something. Zero polling and very
> >> > > simple...
> >> >
> >> > Except that you have to check all of the wakelocks periodically in a loop =>
> >> > polling.  So?
> >>
> >> Why do you need to check them? If you're taking this approach you just
> >> have something like:
> >>
> >> suspend_unblock() {
> >>       if (atomc_dec_and_test(&suspend_lock))
> >>               suspend();
> >> }
> >>
> >> and then check that the lock count is still 0 after device_suspend().
> >> There's no need to poll.
> >
> > I was talking about wakelocks as originally proposed.
> 
> Can you be more specific? My wakelock implementation triggers suspend
> when the active list becomes empty. No polling required.

Sorry, I overlooked and/or didn't remember that.  My bad.

Rafael

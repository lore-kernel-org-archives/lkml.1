Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZBRAUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZBRAUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbZBRAUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:20:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40897 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbZBRAUD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:20:03 -0500
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: Arjan van de Ven <arjan@infradead.org>
CC: Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>, Len Brown <lenb@kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Date: Tue, 17 Feb 2009 18:18:59 -0600
Subject: RE: [RFD] Automatic suspend
Thread-Topic: [RFD] Automatic suspend
Thread-Index: AcmRXHsHw28cf6E3RTKQDl9tHZd2UQAACbcg
Message-ID: <13B9B4C6EF24D648824FF11BE896716203772614AD@dlee02.ent.ti.com>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com>
	<13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com>
	<20090216145948.6fea81c3@infradead.org>	<200902170019.40599.rjw@sisk.pl>
	<20090216232329.GA15678@srcf.ucam.org>
	<20090217142001.GB12378@bulgaria.corp.google.com>
	<20090217064630.688bf639@infradead.org>
	<20090217145141.GA26158@srcf.ucam.org>
	<20090217065622.3e0a9956@infradead.org>
	<13B9B4C6EF24D648824FF11BE896716203771DD342@dlee02.ent.ti.com>
 <20090217160421.12bc851f@infradead.org>
In-Reply-To: <20090217160421.12bc851f@infradead.org>
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

> On Tue, 17 Feb 2009 09:32:46 -0600
> "Woodruff, Richard" <r-woodruff2@ti.com> wrote:
>
> > > so use range timers / timer slack for those apps that you do not
> > > trust. That is not a big deal, and solves the issue of timer
> > > wakeups...
> >
> > I not so sure it is that straight forward in practice.  End systems
> > integrate a lot of 3rd party software who view performance 1st and
> > have no thought of power.
>
> you know that with the range timers/slack, you can control the
> "rounding" of the timer of the application, right?

I've not explored user space for this.

Can on a per-application basis some controlling application cause timers of a target process to be rounded or is it global? Or do you need to link the new application to use special glib variants (as described in OLS papers a few years ago)?

> You can *directly* throttle the number of wakeups an application causes
> that way to a value you set.

Are you talking about your work as seen in lwn.net summary?

http://lwn.net/Articles/296578/

Your change here does look like something which could be used to control timers.  Don't you still need some dynamic way to set the fuzz/slack if its globally applied?  It seems like you might want some timers precise and others fuzzy.

Would the holding of a wakelock or some activity counter be a good trigger for switching rounding time?  If wakelocks held "minor adjustment" else "major adjustment"

Thanks for the good pointer assuming I understood it in quick scan.

Thanks,
Richard W.



Return-Path: <linux-kernel-owner+w=401wt.eu-S1753315AbZBPPlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbZBPPlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 10:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbZBPPky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 10:40:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:39508 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbZBPPky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:40:54 -0500
Date: Mon, 16 Feb 2009 07:40:48 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090216074048.6d70f17c@infradead.org>
In-Reply-To: <200902160806.17901.oliver@neukum.org>
References: <200902160010.16955.rjw@sisk.pl>
	<1234750360.26036.115.camel@pasglop>
	<20090215182012.3bc6b292@infradead.org>
	<200902160806.17901.oliver@neukum.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009 08:06:13 +0100
Oliver Neukum <oliver@neukum.org> wrote:

> Am Monday 16 February 2009 03:20:12 schrieb Arjan van de Ven:
> > >or
> > > network or similar where the driver cannot shut the device down
> > > without losing the ability to detect activity (ie, switch your PHY
> > > off is nice but you lose the ability to monitor the link for
> > > example).
> > 
> > what this needs is a separation between "interface down, all off"
> > and "interface down enough so that link detection works".
> > Some NICs can go all the way down and still do link detection,
> > others cannot. This is obviously something the driver will know,
> > nothing else in the system should know.
> 
> Why shouldn't user space know the consequences of still requesting
> a service and be able to decide on that basis which services to
> request?

That's not what I said. Userspace should not be the part that goes "oh
this is a realtek not an intel nic, so ..."
That is the drivers job.

Userspace should just be the part that says "I'm interested in link
notifications". The driver then just goes to the lowest power state for
its device that still gives those notifications.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

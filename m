Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbZBROwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbZBROwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 09:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbZBROwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 09:52:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:38360 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbZBROwG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 09:52:06 -0500
Date: Wed, 18 Feb 2009 06:51:58 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090218065158.5efa8536@infradead.org>
In-Reply-To: <200902180953.51171.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0902162144010.24097-100000@netrider.rowland.org>
	<200902180026.55533.rjw@sisk.pl>
	<200902180953.51171.oliver@neukum.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009 09:53:48 +0100
Oliver Neukum <oliver@neukum.org> wrote:

> Am Wednesday 18 February 2009 00:26:53 schrieb Rafael J. Wysocki:
> > > Another possibility is to set up independent runtime PM for the
> > > transport and the device.  This means allowing the possibility
> > > that the transport is suspended while its child (the device) is
> > > not.  This is a little simpler (there's only one idle-timeout per
> > > device, since the link is treated as an independent device), but
> > > it violates the principle of never suspending a parent while
> > > there is an active child.
> > 
> > Well, I think the first approach would be better.
> 
> I am afraid it wouldn't be. How do you deal with shared transports?
> 

realistically, something like this you need to design like this
Step 1) Assume the hardware is smart and can do this for you on the fly,
        but it might need guidance.
        (For many busses there are platforms that do this)
Step 2) For hardware that is not smart, emulate the smartness in the
        driver, with help of the subsystem. These two together have
        the right knowledge to make such decisions.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

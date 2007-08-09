Return-Path: <linux-kernel-owner+w=401wt.eu-S932366AbXHIJ1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbXHIJ1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765290AbXHIJ0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:26:14 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:45939 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764772AbXHIJ0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:26:12 -0400
Date: Thu, 9 Aug 2007 11:26:47 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Javier Pello <javier.pello@urjc.es>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not
 notified
Message-ID: <20070809112647.4006c044@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <46BADAA8.70404@urjc.es>
References: <46B37CF7.2020803@urjc.es>
	<20070806142451.5d28d41c@gondolin.boeb
 lingen.de.ibm.com>
	<46B7832B.6010808@urjc.es>
	<20070807125844.4d756b04@gondo
 	l	in.boeblingen.de.ibm.com>
	<3ae72650708070446y6452d13jb7cd802119dab3ce@mail .gmail.com>
	<20070807141030.1bb0f76a@gondolin.boeblingen.de.ibm.com>
	<46B869C6.3090708@urjc.es>
	<1186491472.3611.33.camel@lov.localdomain>
	<46B87ACA.7010501@urjc.es>
	<1186495705.3611.39.camel@lov.localdomain>
	<46BADAA8.70404@urjc.es>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Aug 2007 11:13:12 +0200,
Javier Pello <javier.pello@urjc.es> wrote:

> On Tue, 07 Aug 2007, Kay Sievers wrote:
> > Nope, you would just fulfill in a completely generic way all outstanding
> > requests when you are ready. All requests are all nicely grouped and
> > visible in sysfs. There would be no need of coding your own device
> > specific rebind. No timeout is needed or wanted, all requests would stay
> > until userspace has handled them successfully or canceled them.
> 
> If I'm not mistaken, as it is now, requests are not grouped in any way.
> The only hint that a firmware loading request is in progress are a couple
> of files in the device directory in sysfs. Should I run, at boot, through
> all the device directories to check which firmware requests are pending?

I think that is what Kay meant.

> Also, this could pose problems if two drivers can handle a device but
> the first that gets to bind to it needs firmware and userspace doesn't
> provide it or cancel the loading. The device will remain bound without
> giving the other driver a chance to handle it.

Yes, this relies on someone canceling the load. If the driver has a
two-stage probe for which the first stage kicks the async firmware
loading and the second stage triggers an unbind if the loading fails,
this will work. Otherwise you'll have to manually unbind on load
cancellation. You'll also have to bind to the other driver manually.

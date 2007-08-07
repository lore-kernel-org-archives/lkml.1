Return-Path: <linux-kernel-owner+w=401wt.eu-S934349AbXHGOFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934349AbXHGOFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbXHGOFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:05:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:51352 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbXHGOFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:05:23 -0400
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not 
	notified
From: Kay Sievers <kay.sievers@vrfy.org>
To: Javier Pello <javier.pello@urjc.es>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
In-Reply-To: <46B87ACA.7010501@urjc.es>
References: <46B37CF7.2020803@urjc.es>
	 <20070806142451.5d28d41c@gondolin.boeb lingen.de.ibm.com>
	 <46B7832B.6010808@urjc.es>
	 <20070807125844.4d756b04@gondo  l	in.boeblingen.de.ibm.com>
	 <3ae72650708070446y6452d13jb7cd802119dab3ce@mail .gmail.com>
	 <20070807141030.1bb0f76a@gondolin.boeblingen.de.ibm.com>
	 <46B869C6.3090708@urjc.es> <1186491472.3611.33.camel@lov.localdomain>
	 <46B87ACA.7010501@urjc.es>
Content-Type: text/plain
Date: Tue, 07 Aug 2007 16:08:25 +0200
Message-Id: <1186495705.3611.39.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/FJcMrIPjXtCzSRo0hp8unq8ANgR4Vu0nDLue
 j1k1k81lu8KA8Ha7oS0k43k8yhuO/UJlUmBQFO0+A6wMhbIjhF
 RqU6jBO9dl4Rwl6uZ9lm6zVlrlIjO15
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-08-07 at 15:59 +0200, Javier Pello wrote:
> On Tue, 07 Aug 2007, Kay Sievers wrote:
> 
> > If you don't have modules and the initial request fails, how do you
> > load the firmware later?
> 
> I trigger a rebinding of the device to the driver in an init file:
> # echo -n [device] >/sys/.../bind
> 
> > The real fix would be to change the driver not to block in the
> > firmware request and use async version of firmware loading. The
> > whole firmware class with its silly timeout is just a piece of
> > crap, that needs to be replaced.
> 
> I don't think that would be a real fix. You've done away with the
> kernel blocking, but the timeout is still there, only that in the
> background, and my point is still true: it is useless to wait at
> all if userspace didn't receive the event. Waiting asynchronously
> is less annoying than waiting synchronously, but equally useless.

Nope, you would just fulfill in a completely generic way all outstanding
requests when you are ready. All requests are all nicely grouped and
visible in sysfs. There would be no need of coding your own device
specific rebind. No timeout is needed or wanted, all requests would stay
until userspace has handled them successfully or canceled them.

Kay


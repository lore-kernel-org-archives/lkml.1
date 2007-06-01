Return-Path: <linux-kernel-owner+w=401wt.eu-S1761825AbXFAP76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761825AbXFAP76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 11:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759157AbXFAP7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 11:59:47 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:12835 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759222AbXFAP7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 11:59:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lKX7DGtRmIkIXEMVpB7F4CHV8hn9C2X3d0UGQvsPSu8L+XXPK956UYqMFUwhmX6kACSbbN7JMyPKv/+EgwipFCMpJoMAOphbWh3ianqmDX9sBbhNTEa74U2iYEZMH9UcCWULv0zXSAquuS888oY9Pr82mOeHu5zrESAGp8HAT5o=
Subject: Re: [patch] Move led attributes out of device name and into sysfs
	attributes, was Re: LED devices
From: Richard Hughes <hughsient@gmail.com>
To: Richard Purdie <rpurdie@openedhand.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       "kay.sievers" <kay.sievers@vrfy.org>,
       "Bryn M. Reeves" <breeves@redhat.com>, John Lenz <lenz@cs.wisc.edu>
In-Reply-To: <1180712592.6390.139.camel@localhost.localdomain>
References: <1180710270.3782.5.camel@localhost.localdomain>
	 <1180712592.6390.139.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 01 Jun 2007 16:59:39 +0100
Message-Id: <1180713579.12843.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-01 at 16:43 +0100, Richard Purdie wrote:
> On Fri, 2007-06-01 at 16:04 +0100, Richard Hughes wrote:
> > Patch attached corrects all the brokenness with the led class (encoding
> > some attributes in the device handle).
> 
> For the benefit of LKML, there has been some discussion of this
> elsewhere. My arguments do not particularly come across in Richard's
> choice of quoting and I'm a little annoyed he's chosen to do things this
> way, particularly before any further feedback from Greg/Kay but so be
> it.

To be honest, I didn't want to do this, but you would not accept my
argument - and you wanted to add _more_ properties into the device
handle.

> Greg said that the LEDs class should export any property data as a class
> attribute rather than this just being available in the device name. I
> added the patch in
> http://git.o-hand.com/?p=linux-rpurdie-leds;a=shortlog;h=for-mm to deal
> with this, without breaking the existing LED naming and documented API.

Yes, but as you'll notice with my patch, lots of the users that use the
led class do not use the handle:colour name, and so stripping off
second : parameter for the color attribute was just wrong. And ugly.

> Greg said that the only requirement on bus id naming was that it needed
> to be unique so this should therefore be compatible. HAL could then go
> ahead and ignore the device name, all the attributes are there in the
> fashion it needs which was the original complaint.

But when I was investigating adding led class support to thinkpad_acpi I
couldn't use the existing LED class, as some of the LED's did not have a
pre-defined colour, but did have a description. Again, adding support
into HAL was made more difficult until you proposed screenscaping the
led colour from the device name. This isn't very nice.

> I accept this is basically out of my hands now. Greg/Kay have the
> appropriate emails and if they'll let me know which approach they want
> to take, I'll apply an appropriate patch. I'd suggest not applying this
> patch directly as it introduces a race in the error path it alters.

Sure, I really wanted to convert the class to struct device (which I'm
more familiar with) but just tried to do minimal changes. What changes
need to be made to avoid a race? Thanks.

Richard.



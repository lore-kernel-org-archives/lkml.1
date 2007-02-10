Return-Path: <linux-kernel-owner+w=401wt.eu-S1752191AbXBJJf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbXBJJf4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 04:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbXBJJf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 04:35:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60845 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbXBJJfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 04:35:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: [PATCH] Re: NAK new drivers without proper power management?
Date: Sat, 10 Feb 2007 10:34:03 +0100
User-Agent: KMail/1.9.5
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.osdl.org>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <45CD24F6.8090107@shaw.ca> <1171076554.10170.5.camel@nigel.suspend2.net>
In-Reply-To: <1171076554.10170.5.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702101034.04410.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, 10 February 2007 04:02, Nigel Cunningham wrote:
> Hi.
> 
> On Fri, 2007-02-09 at 19:50 -0600, Robert Hancock wrote:
> > It also kind of bothers me that if a driver has no suspend/resume 
> > functions, and you suspend and resume the system, we don't complain 
> > about it even though there's a very good chance that device is not going 
> > to function properly. How about something in dmesg like:
> > 
> > Warning: driver for device XXXX has no suspend or resume support.
> > Device may not function properly after resume.
> > 
> > so that users know who to complain to. Maybe there are some devices that 
> > truly don't need any handling for suspend, but if so I suspect the 
> > number of those is small enough that adding empty functions would be a 
> > good-enough solution.
> 
> Here's my current version of a patch to do this, if anyone wants to try
> it out. It dumps stack with the warning to make it easier to see what
> the source of the message is:

I have an alternative idea.

There is a test mode of swsusp that's triggered with
"echo test > /sys/power/disk" and "echo disk > /sys/power/state".  We can make
it set a switch that will be used to trigger the warnings in the core.

This way the warnings will only appear in the user's dmesg in the test mode
and not always.

Would that be acceptable?

Rafael

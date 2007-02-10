Return-Path: <linux-kernel-owner+w=401wt.eu-S1752243AbXBJKct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbXBJKct (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 05:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbXBJKcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 05:32:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:32778 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbXBJKck convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 05:32:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: [PATCH] Re: NAK new drivers without proper power management?
Date: Sat, 10 Feb 2007 11:30:43 +0100
User-Agent: KMail/1.9.5
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.osdl.org>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <200702101034.04410.rjw@sisk.pl> <1171101723.3821.22.camel@nigel.suspend2.net>
In-Reply-To: <1171101723.3821.22.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200702101130.44471.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, 10 February 2007 11:02, Nigel Cunningham wrote:
> Gidday.
> 
> On Sat, 2007-02-10 at 10:34 +0100, Rafael J. Wysocki wrote:
> > On Saturday, 10 February 2007 04:02, Nigel Cunningham wrote:
> > > On Fri, 2007-02-09 at 19:50 -0600, Robert Hancock wrote:
> > > > It also kind of bothers me that if a driver has no suspend/resume 
> > > > functions, and you suspend and resume the system, we don't complain 
> > > > about it even though there's a very good chance that device is not going 
> > > > to function properly. How about something in dmesg like:
> > > > 
> > > > Warning: driver for device XXXX has no suspend or resume support.
> > > > Device may not function properly after resume.
> > > > 
> > > > so that users know who to complain to. Maybe there are some devices that 
> > > > truly don't need any handling for suspend, but if so I suspect the 
> > > > number of those is small enough that adding empty functions would be a 
> > > > good-enough solution.
> > > 
> > > Here's my current version of a patch to do this, if anyone wants to try
> > > it out. It dumps stack with the warning to make it easier to see what
> > > the source of the message is:
> > 
> > I have an alternative idea.
> > 
> > There is a test mode of swsusp that's triggered with
> > "echo test > /sys/power/disk" and "echo disk > /sys/power/state".  We can make
> > it set a switch that will be used to trigger the warnings in the core.
> > 
> > This way the warnings will only appear in the user's dmesg in the test mode
> > and not always.
> > 
> > Would that be acceptable?
> 
> Well, the original desire was to stop new drivers getting in without
> proper power management.

I know, but I agree with the argument that having a driver without the
suspend/resume support is better than not having the driver at all.
Moreover, if you _know_ which of the drivers you use have no suspend/resume
support, usually you _can_ suspend (at least to disk) and resume anyway - you
only need to unload their modules before the suspend.  Of course, this is not
true for the disk (and related) drivers and for the drivers that cannot be
unloaded.  [I think it generally is not true for the suspend-to-RAM either.]

Also, I think there are quite some drivers already in the tree that don't
support suspend/resume explicitly and honestly we should start from adding the
suspend/resume routines to these drivers _before_ we ban new drivers like that.

> For this to help achieve that aim, one or more 
> of the following would need to happen:
> 
> * developers of new drivers would have to remember to run the test
> after/during writing their driver. Of course if they remember to do
> this, they've already remembered that they need to implement power
> management;
> * you, I or someone else would need to test all these trees before
> Andrew and Linus merge them and report problems to the developers before
> they get their new drivers merged;
> * Andrew or Linus would run it prior to or after merging a whole lot of
> stuff.
> 
> I'm afraid I don't like the chances of any of those things happening, so
> I'm not sure that it is an acceptable alternative from my perspective. 
> 
> Sticking a printk in dmesg doesn't exactly put the problem in flashing
> red 36 point characters before the developer either, but I think they're
> slightly more likely to see it there if only because they might stick
> printks in that they want to read (eg perhaps while debugging the
> driver) and therefore see the message when checking output from the
> driver being loaded/initialised.
> 
> Maybe another alternative would be to make the warnings compile time
> warnings - if that's possible?

Well, maybe.

Still, I'd like to create standard debugging procedures for suspend/resume, so
that if someone reports a problem, we can tell him exactly what to do next.
>From this point of view, the idea of having warnings related to the lack of
.suspend or .resume routines in drivers that will appear in the user's dmesg in
the test mode seems to be a good one. ;-)

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King

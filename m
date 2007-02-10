Return-Path: <linux-kernel-owner+w=401wt.eu-S1946783AbXBJAOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946783AbXBJAOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 19:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946788AbXBJAOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 19:14:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59693 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946783AbXBJAON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 19:14:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: NAK new drivers without proper power management?
Date: Sat, 10 Feb 2007 01:12:23 +0100
User-Agent: KMail/1.9.5
Cc: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, pm list <linux-pm@lists.osdl.org>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <200702100012.17430.rjw@sisk.pl> <1171063690.1484.113.camel@nigel.suspend2.net>
In-Reply-To: <1171063690.1484.113.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702100112.24341.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 10 February 2007 00:28, Nigel Cunningham wrote:
> Hi.
> 
> On Sat, 2007-02-10 at 00:12 +0100, Rafael J. Wysocki wrote:
> > > > I think if CONFIG_PM_DEBUG is set, the core should warn about drivers not
> > > > having .suspend or .resume routines.
> > > 
> > > The only problem with that is, not everyone turns on CONFIG_PM_DEBUG.
> > > CONFIG_PM instead?
> > 
> > Well, I can imagine a driver that doesn't need a .suspend routine, for example,
> > and I don't think we should make the kernel always complain about that.
> 
> How about...
> 
> #ifdef CONFIG_PM_PARANOIA
> static int empty_suspend_routine(struct device *dev, pm_message_t state)
> {
> 	return 0;
> }
> #define empty_suspend empty_suspend_routine
> #else
> #define empty_suspend NULL
> #endif
> 
> ...
> 
> 	.suspend = empty_suspend;
> ...
> 
> 
> Then CONFIG_PM_PARANOIA can be enabled by default for now, and when we
> eventually device it's not needed anymore, someone can submit a patch
> replacing either turning off the CONFIG by default or removing the whole
> mechanism.

I think that would be tempting people to abuse it, for example by defining or
undefining things just to quieten the warning.

In my opinion the only way to make the warning go away should be to define
a non-NULL .suspend (.resume) routine and that's why I don't think the warning
should be mandatory.

> > I think if someone doesn't set CONFIG_PM_DEBUG, we can ask him to set it
> > and report back.
> 
> We can, but the whole point to the suggestion was to make your life and
> mine easier, as well as those of our users.
> 
> Making it dependent on CONFIG_PM instead achieves that by:
> - Saving you, I and distro people from having to tell their users to
> enable the option (and how to)

I think the distro people can patch their kernels to fit their needs.

> - Saving the users the problem of going through all the steps, making
> mistakes, potentially ending up with unbootable systems because they
> make mistakes and so on.
> 
> This way, they just need to look in dmesg.

Well, IMO, if someone doesn't know how to compile and install the kernel,
he'll be using a distro kernel anyway and then see above.  Otherwise we can
safely ask him to turn on whatever debugging options we need.

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King

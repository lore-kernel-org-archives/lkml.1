Return-Path: <linux-kernel-owner+w=401wt.eu-S1752548AbXBIX2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbXBIX2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbXBIX2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:28:15 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:49994 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbXBIX2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 18:28:11 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, pm list <linux-pm@lists.osdl.org>
In-Reply-To: <200702100012.17430.rjw@sisk.pl>
References: <1171058269.1484.64.camel@nigel.suspend2.net>
	 <200702092344.14984.rjw@sisk.pl>
	 <1171061489.1484.100.camel@nigel.suspend2.net>
	 <200702100012.17430.rjw@sisk.pl>
Content-Type: text/plain
Date: Sat, 10 Feb 2007 10:28:10 +1100
Message-Id: <1171063690.1484.113.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, 2007-02-10 at 00:12 +0100, Rafael J. Wysocki wrote:
> > > I think if CONFIG_PM_DEBUG is set, the core should warn about drivers not
> > > having .suspend or .resume routines.
> > 
> > The only problem with that is, not everyone turns on CONFIG_PM_DEBUG.
> > CONFIG_PM instead?
> 
> Well, I can imagine a driver that doesn't need a .suspend routine, for example,
> and I don't think we should make the kernel always complain about that.

How about...

#ifdef CONFIG_PM_PARANOIA
static int empty_suspend_routine(struct device *dev, pm_message_t state)
{
	return 0;
}
#define empty_suspend empty_suspend_routine
#else
#define empty_suspend NULL
#endif

...

	.suspend = empty_suspend;
...


Then CONFIG_PM_PARANOIA can be enabled by default for now, and when we
eventually device it's not needed anymore, someone can submit a patch
replacing either turning off the CONFIG by default or removing the whole
mechanism.

> I think if someone doesn't set CONFIG_PM_DEBUG, we can ask him to set it
> and report back.

We can, but the whole point to the suggestion was to make your life and
mine easier, as well as those of our users.

Making it dependent on CONFIG_PM instead achieves that by:
- Saving you, I and distro people from having to tell their users to
enable the option (and how to)
- Saving the users the problem of going through all the steps, making
mistakes, potentially ending up with unbootable systems because they
make mistakes and so on.

This way, they just need to look in dmesg.

Regards,

Nigel


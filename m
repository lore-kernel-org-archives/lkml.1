Return-Path: <linux-kernel-owner+w=401wt.eu-S1753674AbXDLNrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbXDLNrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 09:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbXDLNrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 09:47:06 -0400
Received: from mx6.mail.ru ([194.67.23.26]:26966 "EHLO mx6.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbXDLNrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 09:47:05 -0400
Date: Thu, 12 Apr 2007 17:43:54 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       dwmw2@infradead.org
Subject: Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070412134354.GA25461@zarina>
Reply-To: cbou@mail.ru
References: <20070411232503.GC20095@zarina> <20070412034323.GA7017@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070412034323.GA7017@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

On Wed, Apr 11, 2007 at 08:43:23PM -0700, Greg KH wrote:
> On Thu, Apr 12, 2007 at 03:25:03AM +0400, Anton Vorontsov wrote:
> > Here is battery monitor class. According to first copyright string, we're
> > maintaining it since 2003. I've took few days and cleaned it up to be
> > more suitable for mainline inclusion.
> > 
> > It differs from battery class at git://git.infradead.org/battery-2.6.git:
> 
> Why fork from David's work?  Does he not like these changes for some
> reason?

It's not a fork, actually. Ian Molton started battery stuff years before
David's work.

Though ours and David's exported API functions are exactly the same
(don't count functions which are unique for our code), but our
implementation a little intersects with David's.

For me it was no matter if I'll take handhelds.org or David's code as a
start point, except that hh.o code familiar to me, and I can test it on
real devices.

Though, you're right, we're in situation when we've two battery classes
now. :-/ And another pity fact is that we also have 8 Mb of patches in
our CVS. It takes a lot of time to to cleanup code for mainline,
especially with limited man-power resources. But we're working hard.

So, this is brief explanation why it took so long for us to show up.

> > +static int battery_create_attrs(struct battery *bat)
> > +{
> > +	int rc;
> > +
> > +	#define create_bat_attr_conditional(name)                    \
> > +	if(bat->get_##name) {                                        \
> > +		rc = device_create_file(bat->dev, &dev_attr_##name); \
> > +		if (rc) goto name##_failed;                          \
> > +	}
> > +
> > +	create_bat_attr_conditional(status);
> > +	create_bat_attr_conditional(min_voltage);
> > +	create_bat_attr_conditional(min_current);
> > +	create_bat_attr_conditional(min_capacity);
> > +	create_bat_attr_conditional(max_voltage);
> > +	create_bat_attr_conditional(max_current);
> > +	create_bat_attr_conditional(max_capacity);
> > +	create_bat_attr_conditional(temp);
> > +	create_bat_attr_conditional(voltage);
> > +	create_bat_attr_conditional(current);
> > +	create_bat_attr_conditional(capacity);
> 
> Use an attribute group please.  It's much simpler and will be created at
> the proper time so your userspace tools don't have to sit and spin in
> order to properly wait for them to show up.
> 
> Ok, yes, you want a conditional type of attribute group, like the
> new firewire code does.  I have no problem adding that if you like.

I'm not sure if it's possible to create that type of conditional
attribute group. Because the condition is "bat->func != NULL", not
attribute' function. And that condition is battery-specific, not class
specific.

But anyway, I guess you're talking about not yet existent API, so I'd be
glad to take a look.

> thanks,
> 
> greg k-h

Thanks for comments!

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2

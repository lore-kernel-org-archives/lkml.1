Return-Path: <linux-kernel-owner+w=401wt.eu-S965549AbXDLQzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965549AbXDLQzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965558AbXDLQzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:55:09 -0400
Received: from mx6.mail.ru ([194.67.23.26]:20182 "EHLO mx6.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965549AbXDLQzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:55:05 -0400
Date: Thu, 12 Apr 2007 20:51:51 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       dwmw2@infradead.org
Subject: Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070412165151.GA2984@zarina>
Reply-To: cbou@mail.ru
References: <20070411232503.GC20095@zarina> <20070411195359.2983b857.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070411195359.2983b857.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Randy,

On Wed, Apr 11, 2007 at 07:53:59PM -0700, Randy Dunlap wrote:
> On Thu, 12 Apr 2007 03:25:03 +0400 Anton Vorontsov wrote:
> > +void battery_status_changed(struct battery *bat)
> > +{
> > +	pr_debug("%s\n", __FUNCTION__);
> > +	#ifdef CONFIG_LEDS_TRIGGERS
> 
> Please don't indent preprocessor controls (ifdef/endif etc.).
...
> Place 'switch' and 'case' at the same indent level.  This prevents
> the "double-indent" for the code statements.
...
> We usually try to place a blank line between local data and code.
...
> 	space after "if"
...

Much thanks, will fix.

> > +		device_remove_file(bat->dev, &dev_attr_##name);
> > +
> > +	goto success;
> > +
> > +capacity_failed:     remove_bat_attr_conditional(current);
> > +current_failed:      remove_bat_attr_conditional(voltage);
> > +voltage_failed:      remove_bat_attr_conditional(temp);
> > +temp_failed:         remove_bat_attr_conditional(max_capacity);
> > +max_capacity_failed: remove_bat_attr_conditional(max_current);
> > +max_current_failed:  remove_bat_attr_conditional(max_voltage);
> > +max_voltage_failed:  remove_bat_attr_conditional(min_capacity);
> > +min_capacity_failed: remove_bat_attr_conditional(min_current);
> > +min_current_failed:  remove_bat_attr_conditional(min_voltage);
> > +min_voltage_failed:  remove_bat_attr_conditional(status);
> 
> I thought there was a class_remove() or something like that?
> but I'm not sure of it.

[class_]device_destroy()? Yeah, but it's exactly same thing as
[class_]device_unregister.

But this is really good question. Should I manually clean up attributes,
or sysfs will take care? I.e. whole battery directory removes, and
sysfs removes files in it, or they just leaks?

I've took worst scenario, and done removal manually (I've grep'ed in
drivers/, and almost every driver also doing so).

> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

Thanks for comments!

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2

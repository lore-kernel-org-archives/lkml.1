Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbXHQTua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbXHQTua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 15:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbXHQTuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 15:50:14 -0400
Received: from smtp106.sbc.mail.re2.yahoo.com ([68.142.229.99]:39199 "HELO
	smtp106.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752934AbXHQTuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 15:50:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uDNrgnHMj4mauHI0F/0gWp7xo9FY9O4NwzN/qn3UiOYWBrTnMsniV58qaXYVzRto1F1eahwN8r9zGsEI6A8I9INPLzVpBlNCulmv9ZuJxDlfu09qXj5DF0m0PzOLiF33IP9+EzONHnnmsR1b2UDX+m3Pd0C9dyc0FHJGJeT4twI=  ;
X-YMail-OSG: 6l6SDuEVM1l8bRCMJ6bN8cQL17eSe2nOqBRAjwPSWYtwT2FRkaTyBS_WWOeFYTBsORpo_gMYAbL17H8YW1lrXnl59Bf5fXH0VYUMBy50kkOkOyZnucIj_UghIUGL_fOOYYTBJ3GZlOWM.VI-
From: David Brownell <david-b@pacbell.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
Date: Fri, 17 Aug 2007 12:50:09 -0700
User-Agent: KMail/1.9.6
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, jengelh@computergmbh.de,
       a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, Greg KH <greg@kroah.com>
References: <200708170823.15894.david-b@pacbell.net> <200708170955.06388.david-b@pacbell.net> <1187371126.4253.10.camel@lov.localdomain>
In-Reply-To: <1187371126.4253.10.camel@lov.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708171250.09653.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2007, Kay Sievers wrote:
> On Fri, 2007-08-17 at 09:55 -0700, David Brownell wrote:
> > On Friday 17 August 2007, Kay Sievers wrote:
> > > Again,
> > 
> > "Again"?
> 
> We exchanges several mails a few weeks ago after the Debian bug caused
> by a modprobe loop. 

Which has been fixed for some time now; it was caused by legacy
drivers, which are incapable of hotplugging.


> > > the only sane solution is to provide MODALIAS="platform:<name>" 
> > > from the platform bus, and adding the aliases to drivers who support
> > > autoloading. Modalias strings are not free-text strings, they are
> > > required to be prefixed by the subsystem.
> > 
> > If so, then whoever tried to change the usage of module aliases
> > in that way goofed in several ways.  First, by not changing all
> > the in-kernel uses.  Second, by not changing all the out-of-tree
> > uses in various distros, toolchains, etc.  Third, by not even
> > documenting that change...
> 
> Yes, please fix the misuse of MODALIAS.

I'm not the one who's advocating a change here.  If you want to
first change/break and then fix things, all of that is up to you.


> > > Please change that stuff, and the bugs which we 
> > > are fighting magically go away, because module-init-tools alias
> > > resolving works like it does for every other subsystem in the kernel.
> > 
> > Those bugs would be ... what?  "We" haven't observed anything
> > attributable to this usage, which has been common for years now.
> 
> Loops of modprobe by modules requesting itself, you worked around that
> in the recent kernel,

Legacy drivers of the "create my own device node" ilk will never
be able to hotplug ... since it's the /sys/device/... node creation
which causes any "find my driver" hotplug event.  (Like "i82365".)

That bug has been *FIXED* for some time now, as far as I hear.

And that's based on having looked at several hundred platform
drivers to make sure of it... mostly that's not legacy code, so
it can hotplug just fine.


> but that broke other setups.

That's news to me.  Of course, the breakage could also be in
those setups ... legacy drivers with legacy setup shouldn't
break, but they don't necessarily obey enough of the rules
that newer tools expect.


> And module-init-tools  
> "blacklist" does not work, because platform uses no alias, but a plain
> driver name. That should be fixed, please, please, please...

Module init tools "blacklist" is squirrely, yes ... it
ignores *most* of the names that "modprobe" accepts,
so it can't actually "blacklist" modules from loading.

The ancient "alias modname none" trick still has life.

- Dave


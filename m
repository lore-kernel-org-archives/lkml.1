Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab0AOKGq (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 05:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456Ab0AOKGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 05:06:45 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39456 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319Ab0AOKGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 05:06:44 -0500
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jan 2010 05:06:44 EST
X-Sasl-enc: t+9AXb8kV11az98GYYhlWRTCkxa9IxYBASk+OQiaTTtR 1263549479
Message-ID: <4B503C26.7040902@ladisch.de>
Date: Fri, 15 Jan 2010 10:57:58 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v3] k10temp: temperature sensor for AMD Family 10h/11h
 CPUs
References: <4AF91F70.10106@ladisch.de>	<4B06501B.8080509@ladisch.de>	<87ws1l5wcl.fsf@depni.sinp.msu.ru>	<4B0673D7.5010006@ladisch.de>	<20091120123016.19d98ab4@hyperion.delvare>	<4B068402.7020606@ladisch.de>	<20091120131855.7f8f8722@hyperion.delvare>	<4B0A3DB6.9090703@ladisch.de>	<20091123145154.5b2b5735@hyperion.delvare>	<4B0AAA55.3040702@ladisch.de>	<20091123200527.1114cbc2@hyperion.delvare>	<4B0B9CB1.3090808@ladisch.de>	<20091124142654.76f4d166@hyperion.delvare>	<4B0BE935.1050708@ladisch.de>	<20091124211134.12971937@hyperion.delvare>	<4B0CFE2A.6010008@ladisch.de>	<20091126214429.6ac22d3f@hyperion.delvare>	<4B0FCE21.9070007@ladisch.de> <20100110154549.1e5d0098@hyperion.delvare>
In-Reply-To: <20100110154549.1e5d0098@hyperion.delvare>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Fri, 27 Nov 2009 14:03:29 +0100, Clemens Ladisch wrote:
> > +temp[1-*]_scale	Temperature scale type.
> > +		0: millidegrees Celsius (default if no _scale entry)
> > +		1: relative millidegrees Celsius; see below
> > +		2: millivolts; see below
> > +		other values: unknown
> 
> Maybe, yes. I am a little worried that older versions of libsensors
> will ignore this attribute. The good thing about this is that users
> will still get some value until they upgrade. The bad thing is that
> they will not know that the value isn't absolute. They are likely to
> get frightened by unexpected values and/or to complain to us about them.
> 
> I am wondering if a totally separate channel type wouldn't be
> preferable. The pros and cons would be inverted of course: older
> versions of libsensors would have zero support for that, and all
> applications would have to be updated to support it, but at least the
> meaning of the value would be totally clear. This would come at the
> price of some code duplication both in libsensors and applications
> though.
> 
> I guess it basically depends whether we want to consider a thermal
> margin as a "temperature measurement except that it's relative" or as
> something completely separate.

It's different from the millidegree/millivolt issue; millivolts can be
transparently converted by libsensors, while relative values must be
handled/displayed differently by the application.  So I think at least
in the libsensors API, relative values should be different.

(In any case, we should add temp#_scale at least for millivolts.)

> Honestly, I've been thinking about this
> for some time now and I simply don't know what we'd rather do :(

The sysfs interface is a somewhat internal interface; I think the main
question is whether old userspace (old libsensors or old apps using a
new libsensors) should be able to see relative values without knowing
that they are relative.

Coretemp and k10temp already exist and show relative values.  If we
introduced a new channel for relative values now, we would still have
problems with those drivers, so it might already be too late to avoid
problems for old userspace.


Best regards,
Clemens

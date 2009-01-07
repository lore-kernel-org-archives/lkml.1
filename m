Return-Path: <linux-kernel-owner+w=401wt.eu-S1757104AbZAGEwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbZAGEwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 23:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbZAGEwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 23:52:23 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:47572 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbZAGEwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 23:52:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=Bt5pc15grlK2JZsmsC8fffoldnE1anVviWhD5ypjeCXbGoFwrEG74thnqfc0rXp0ty
         OqWpQO1bCaSmtUEPanwTi6sD0zsXtk4vT9AN2TWMML30gwnval/rCARypp76vdgqt6TM
         oZGMTJPdtBxqdZ9SmkpU4oZpXuKXYZf3OaHq0=
Message-ID: <3ae3aa420901062052h75fcab11n8ce45c41ac0e4cd2@mail.gmail.com>
Date: Tue, 6 Jan 2009 22:52:20 -0600
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: mayer@ntp.isc.org
Subject: Re: [ntpwg] Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: david@lang.hm, "Robert Hancock" <hancockr@shaw.ca>,
       "Ben Goodger" <goodgerster@gmail.com>,
       "Kyle Moffett" <kyle@moffetthome.net>,
       MentalMooMan <slashdot@jameshallam.info>,
       "David Newall" <davidn@davidnewall.com>, linux-kernel@vger.kernel.org,
       ntpwg@lists.ntp.isc.org, "Travis Crump" <pretzalz@techhouse.org>,
       burdell@iruntheinter.net, "Nick Andrew" <nick@nick-andrew.net>,
       "Jeffrey J. Kosowsky" <jeff@kosowsky.org>
In-Reply-To: <49642674.9080703@ntp.isc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495F0672.6020708@davidnewall.com> <4961432A.80509@davidnewall.com>
	 <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>
	 <49614835.7000505@davidnewall.com>
	 <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>
	 <20090105143335.GC18055@mail.local.tull.net>
	 <3ae3aa420901050808r100e533fo5f88edfbb5f0747a@mail.gmail.com>
	 <alpine.DEB.1.10.0901050949560.27641@asgard.lang.hm>
	 <3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com>
	 <49642674.9080703@ntp.isc.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/6 Danny Mayer <mayer@ntp.isc.org>:
Hi,

> I don't know what this discussion is really about and why this was sent
>  to the working group in the middle of the discussion, but there is no
> need for NTP to provide TAI information since NTP only uses UTC. Leap
> Seconds are automatically signaled  and incorporated when they become
> due. If you don't have NTP running for some reason when a leap second is
> signaled it doesn't matter since your server source will already have
> incorporated the leap second so the NTP packet includes the timestamps
> that include the leap second adjustment.
>
> Operating Systems use UTC and not TAI by universal agreement and the
> ones that don't are extremely rare.
>
> Why don't you tell us what the real problem is instead of telling us
> that you need TAI offset information?

Currently, the Linux kernel keeps time in UTC. This means
that it must take special actions to tick twice when a leap
second comes by.  Due to a (stupid) bug, some fraction
of linux systems crashed; this includes everything from
laptops to servers, to DVR's,  to cell phones and cell
phone towers. There's now a fix for this.

However, during the discussion, the idea came out that
maybe keeping UTC time in the kernel is just plain stupid.
So there's this idea floating around that maybe the kernel
should keep TAI time instead. The hope is that this will
reduce the complexity in the kernel, and push it out to
user space, "where it belongs" (to repeat a well-worn
mantra).

However, *if* we were to kick UTC out of the kernel,
and push it to user-land, then, of course, there's a
different problem: how does the kernel know what the
correct TAI time is?  As your reply makes abundantly
clear, NTP is not a good source for TAI information.

The comments which you labelled as "non-sense" were
a mis-understanding of  a discussion of a particular issue
that would arise if the kernel were to keep TAI -- if it did,
then user-space systems would need to have a reliable
source for leap-seconds. Since NTP does not
provide this, there was discussion about how that
could be worked-around. This then lead to the comment
that, "gee, wouldn't the right long-term solution be that
NTP provide TAI info?"

Clearly, it would be a lot of work to get the kernel to keep
TAI instead of UTC, so this is not, at this time, a "serious
proposal".  But if it were possible, and all the various
little issues that result were solvable, then it does seem
like a better long-term solution.

--linas

p.s. the opinions above are not my own; I'm just
summarizing the points made by the most vocal
posters to this list.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbYCMJQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbYCMJQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 05:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYCMJQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 05:16:20 -0400
Received: from phunq.net ([64.81.85.152]:36732 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752061AbYCMJQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 05:16:19 -0400
From: Daniel Phillips <phillips@phunq.net>
To: david@lang.hm
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Thu, 13 Mar 2008 01:16:02 -0800
User-Agent: KMail/1.9.5
Cc: David Newall <davidn@davidnewall.com>, Chris Friesen <cfriesen@nortel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803130106.26910.phillips@phunq.net> <alpine.DEB.1.00.0803130133470.22040@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.00.0803130133470.22040@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803130216.03230.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 01:39, david@lang.hm wrote:
> > Feel free.  You use your script, and somebody with a reliable UPS or
> > two can use my driver, once it is stabilized of course.  Just don't be
> > in business against them if being a few milliseconds slower on the
> > uptake means money lost.
> 
> so now you are saying that you are faster then a ramdisk?????

No, I am saying that my driver is faster than any script you can write.
Your script will not be able to give access to data while the ramdisk
is being populated, nor will it be able to save efficiently exactly
what is dirty in the ramdisk.  (Explained in my original post if you
would like to take a look.)

> if you have a reliable UPS and are willing to rely on it to save your data 
> take the identical hardware to what you are planning to use, but instead 
> of using your driver just create a ramdisk and load it on boot and save 
> the contents on shutdown.

Aha!  You are getting close.  Really, that is all ramback does.  It
just handles some very difficult related issues efficiently, in such a
way as to minimize any denial of service from complete loss of UPS
power.  This is all just about using power management in a new way that
gets higher performance.  But your battery power has to be reliable.
Just make it so.  It is not difficult these days, or even particularly
expensive.

I calculated somewhere along the line that it would take something like
17 minutes to populate the big Violin ramdisk initially, and 17 minutes
to save it during a loss of line power event, during which UPS power
must be not run out before ramback achieves disk sync or you will get
file corruption.  (This rule was mentioned in my original post.)

All well and could, you can in fact do that with a pretty simple script.
But in the initial 17 minutes your application may not read or write
the ramdisk data and in the closing 17 minutes it may not write.  That
knocks your system down to 4 nines, given one planned shutdown per year.
Not good, not good at all.

See, ramback is entirely about _not_ getting knocked down to 4 nines.
It wants to stay above 6, given system components that satisfy that goal,
comprising:

  * Linux
  * Processor, memory, motherboard etc
  * Dual power supplies with independent UPS backup
  * Ramback driver

My proposition is, you can go out and purchase hardware right now that
delivers 6 nines (30 seconds downtime/year) and yes, it will cost you,
but if that worries you then set up two (much) cheaper ones and set
them up as a failover cluster.  (Helps that the Violin box can connect
via PCI-e to two servers at the same time.)

I say you can do this reliably.  It boils down to your power supplies.
You say it can't be done.  Who is right?

Daniel

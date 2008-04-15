Return-Path: <linux-kernel-owner+w=401wt.eu-S1760139AbYDOXbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139AbYDOXbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 19:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYDOXbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 19:31:38 -0400
Received: from rv-out-0708.google.com ([209.85.198.250]:30155 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753239AbYDOXbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 19:31:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=PynW3tV1emn+KE6SLNnZGaKOSd4wvx/DmohU9Ev2dKRcXM8t1hRRcYnww8X2zaASAF5GIS9OB3EDRtLsRkP/r8Ghb6igQyK8c8qPfVkO68OieJ1lEO+aeI3umfrkyAzNCvHW4UgezjGo7A0YdXqv00HhLw8TyqZKwAvjKO7R5TM=
Message-ID: <48053AD1.8010007@gmail.com>
Date: Wed, 16 Apr 2008 08:31:29 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Frans Pop <elendil@planet.nl>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
References: <200804021524.27222.elendil@planet.nl> <200804021820.04610.elendil@planet.nl> <20080402194938.GI24237@csclub.uwaterloo.ca> <200804031947.07674.elendil@planet.nl> <48017248.4030600@gmail.com> <20080414134734.GB7385@csclub.uwaterloo.ca> <20080414145302.4239b0b9@core> <480414E6.2090205@gmail.com> <20080415144748.GO7385@csclub.uwaterloo.ca>
In-Reply-To: <20080415144748.GO7385@csclub.uwaterloo.ca>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Lennart Sorensen wrote:
> Yes.  After all you would quickly see a problem if you built a kernel
> with all the IDE drivers built in, which some people do.  In that case
> ide generic is always activated last and anything bad that would happen
> with loading a module would happen built in too.

Yeah, pick the right configuration.  You can make it malfunction.

> I think it is the wrong place to worry about problems.  If a native
> driver takes control of a chip, it is that drivers responsibility to
> reserve any relevant ports on that chip sufficiently to prevent another
> driver from messing with it that doesn't know anything about that chip.
> If the native driver doesn't load at all, then ide-generic ought to try
> and drive the chip if it has legacy ports.

I'm not too sure whether that will be always possible and I'm less sure 
we'll get enough test coverage over this kind of stuff.

> So my opinion is that making life easy to those machines with legacy ide
> ports is a good thing, while trying to be overly paranoid about one
> driver potentially hitting a bug in another driver is just silly.  Why
> couldn't two native ide drivers potentially go looking for the same
> ports too?  Are you sure no native driver uses the legacy IDE port
> numbers to control a chip in native mode?  Finding bugs is good since
> then they can be fixed.  Trying to prevent hitting bugs (which shouldn't
> be there in the first place) doesn't seem useful.

Yeah, theoretically, you're right.  The problem is that what breaks when 
things go wrong.  If you don't probe generic ports by default, harddisks 
won't be detected on some legacy systems but you can always prompt the 
user about loading the generic driver.  If you probe generic ports by 
default, when things go wrong, you break modern machines in an 
unrecoverable (w/o reset) way.  I'd rather choose bothering the user on 
legacy machines.

thanks.

-- 
tejun

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbYCZEiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbYCZEiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 00:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYCZEiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 00:38:09 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3532 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYCZEiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 00:38:08 -0400
X-Greylist: delayed 753 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Mar 2008 00:38:07 EDT
From: Roman Zippel <zippel@linux-m68k.org>
To: john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 7/8] Remove current_tick_length()
Date: Wed, 26 Mar 2008 02:53:20 +0100
User-Agent: KMail/1.9.9
Cc: Ray Lee <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <20080314184001.695807682@linux-m68k.org> <Pine.LNX.4.64.0803151812020.1791@scrub.home> <1205802064.28128.74.camel@localhost>
In-Reply-To: <1205802064.28128.74.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803260253.21921.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 18. March 2008, john stultz wrote:

> On Sat, 2008-03-15 at 18:14 +0100, Roman Zippel wrote:
> > Hi,
> >
> > On Sat, 15 Mar 2008, Ray Lee wrote:
> > > Then make the original function an inline. With -O2 it should compile
> > > to exactly the same thing.
> >
> > This would also defeat John's intention of keeping the value static.
>
> Well, don't mistake me for being fanatical about it. Having the values
> be static is cleaner, but if its a real performance issue, then clearly
> performance wins.

There are two aspects, such functions tend to generate slightly larger and 
slower code.

> I do like Ray's suggestion, and think using the inline'd function is
> preferred to the raw variable, as it better establishes through use if
> nothing else, the read-only nature of the value outside of ntp.

In other languages one would use private or protected for this, but we don't 
have this. I'm not too fond of an inline function, as it would mark it as 
some kind of public API, which it isn't. It's just an internal value used by 
the timekeeping code, which happens to be needed by a few source files. If 
you want to make a little more private, it would be better to move it to 
header under kernel/time/.

bye, Roman

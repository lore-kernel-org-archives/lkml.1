Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbXDYXmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbXDYXmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbXDYXmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:42:32 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:58836 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbXDYXmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:42:31 -0400
Date: Wed, 25 Apr 2007 19:42:16 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Richard Knutsson <ricknu-0@student.ltu.se>, Jiri Bohac <jbohac@suse.cz>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] fix abs() macro to work with types wider than int
In-Reply-To: <462F75FF.5090008@oracle.com>
Message-ID: <alpine.DEB.0.98.0704251937160.31620@sigma.j-a-k-j.com>
References: <20070419092339.GA13569@dwarf.suse.cz>
 <20070419084339.418dbe69.randy.dunlap@oracle.com> <4628B5B6.90303@student.ltu.se>
 <20070425082028.8ece3094.randy.dunlap@oracle.com>
 <alpine.DEB.0.98.0704251123370.19149@sigma.j-a-k-j.com>
 <462F75FF.5090008@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Can there even be any reason beyond unnecessary pedantics to have [l[l]]abs?
> 
> See Paragraph 1 above.  We do lots of functions in a manner that is
> like C (or libc) so that we don't confuse developers.

I have the perfect solution that includes compatibility while avoiding 
stupidity.

Macro "abs" which evaluates its argument once and uses typeof().

#define labs(n) abs(n)
#define llabs(n) labs(n)

Leave that in the kernel for a year or two. At the end of that time, grep 
the kernel to show that only two silly people actually use them. Change 
those, and remove the aliases. Sense restored.

As far as I'm concerned, the only reason those functions exist like that 
is because standard C doesn't support function overloading and doesn't 
want to promote every argument to the biggest width and -also- can't 
define it as a macro because there's no typeof() in standard C. So since 
we do have it...

...and why do we want people hacking the kernel who get confused by a 
single "abs" function? Isn't that quite a lot like saying "Do not use 
hairdryer while sleeping."?

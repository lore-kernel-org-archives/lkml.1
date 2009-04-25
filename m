Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbZDYHyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbZDYHyw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 03:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZDYHyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 03:54:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41755 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZDYHyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 03:54:43 -0400
To: Alessio Igor Bogani <abogani@texware.it>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Suggestions request for speed-up kernel compilation
From: Andi Kleen <andi@firstfloor.org>
References: <63a49ef40904240257w45cc9c03n6e71ff4e4f69209b@mail.gmail.com>
Date: Sat, 25 Apr 2009 09:54:40 +0200
In-Reply-To: <63a49ef40904240257w45cc9c03n6e71ff4e4f69209b@mail.gmail.com> (Alessio Igor Bogani's message of "Fri, 24 Apr 2009 11:57:35 +0200")
Message-ID: <878wlpkw1r.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alessio Igor Bogani <abogani@texware.it> writes:

> I'm a kernel newbie and I would be very happy to receive some tips
> about kernel compilation from experienced developers.
>

Some tricks:

If you just want to test that the file you've been hacking
on compiles you can use make dir/path/file.o

Use the minimum config file for your machines, 
except for occasional fuller verification builds

Set the right -j make level. You have to experiment 
what is best.

Not enabling CONFIG_DEBUGINFO speeds up compilation significantly

When you use ccache make sure you have the cache directory on
the same partition and enable CCACHE_HARDLINK=1. Alternatively
what also works (but is a bit more expensive) is to put
the ccache cache on a SSD.

What works very well is to throw some money at it -- compilation
scales very well in a cluster. Get the cheapest quad core you can get
as an additional machine and use a tool like icecream
(http://en.opensuse.org/Icecream) to distribute the compilation.

You need special wrappers like 
ftp://firstfloor.org/pub/ak/smallsrc/icecache.c to combine
icecream with ccache

I also found using the "gold" linker in latest binutils
speeds up builds because especially when you already
have parallel compilations the linker is often a bottleneck.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

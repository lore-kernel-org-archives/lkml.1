Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbZG2Sn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbZG2Sn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 14:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZG2Sn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 14:43:28 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:46589 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZG2Sn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 14:43:28 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH] kdesu broken
Date: Wed, 29 Jul 2009 14:43:13 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc3; KDE/4.2.4; i686; ; )
Cc: alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org,
       hirofumi@mail.parknet.co.jp, aneesh.kumar@linux.vnet.ibm.com,
       rjw@sisk.pl, ray-lk@madrabbit.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, stern@rowland.harvard.edu
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
 <200907291340.38620.gene.heskett@verizon.net>
 <200907292028.32320.elendil@planet.nl>
In-reply-to: <200907292028.32320.elendil@planet.nl>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200907291443.13983.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 July 2009, Frans Pop wrote:
>> What is needed for a mistake free bisect is a 'doesn't matter as long
>> as it matches' Makefile version that survives all the way through a
>> bisect run.
>
>I have a wrapper script I use for kernel builds that takes care of that
>(it also supports cross building and building some out-of-tree modules).
>Some snippets from that script below.
>
>BISECTING=
>if [ -e .git/BISECT_LOG ]; then
>        BISECTING=1
>fi
>[...]
>if [ "$BISECTING" ]; then
>        # The version in the next line may need updating before a bisect
>        sed -i "s/^SUBLEVEL = .*/SUBLEVEL = 31/" Makefile
>        sed -i "s/^EXTRAVERSION =.*/EXTRAVERSION = -bisect/" Makefile
>fi
>[...]
>make ...
>[...]
>if [ "$BISECTING" ]; then
>	# Revert Makefile to avoid errors on 'git bisect good/bad'
>        git checkout Makefile
Ahh, I see that now, which I was objecting to below.  I'll go quietly. :)
>fi
>
>I use the deb-pkg target and also set the .deb package version in the
>second hunk:
>KERNELDEBREVISION=$(grep "^git[- ]bisect" .git/BISECT_LOG | wc -l)
>
>This way I end up with a nice series of packages whose numbering matches
>the steps in .git/BISECT_LOG:
>linux-image-2.6.31-bisect_1_amd64.deb
>linux-image-2.6.31-bisect_2_amd64.deb
>linux-image-2.6.31-bisect_3_amd64.deb
>...
>
>Hope that help.
>
>Cheers,
>FJP

Yes, some of it will.  But thanks to fedora's broken disk partitioner, 
something I've been screaming about for a damned decade, my /boot partition 
isn't big enough to absorb a whole chain of those, hence the fixed version 
request.

This script would appear to need a restore function for the Makefile version 
because one of my 'git bisect bad's returned that it couldn't switch branches 
because of the handmade Makefile changes I'd done on the first build.  How 
have you been handling that?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

When you don't know what to do, walk fast and look worried.


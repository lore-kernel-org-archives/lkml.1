Return-Path: <linux-kernel-owner+w=401wt.eu-S1764686AbXHWQ0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764686AbXHWQ0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 12:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXHWQZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 12:25:56 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60374 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbXHWQZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 12:25:55 -0400
Date: Thu, 23 Aug 2007 17:25:53 +0100
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 2.6.23-rc3-mm1
Message-ID: <20070823162553.GB30504@skynet.ie>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC6FB2.1010801@csn.ul.ie> <20070822111029.46db0ab7.akpm@linux-foundation.org> <20070823120742.GR8058@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070823120742.GR8058@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (23/08/07 14:07), Andi Kleen didst pronounce:
> On Wed, Aug 22, 2007 at 11:10:29AM -0700, Andrew Morton wrote:
> > x86_64-mm-less-stack-alignment.patch has
> > 
> > cflags-y += $(call cc-option,-mpreferred-stack-boundary=3)
> > 
> > So we _should_ have detected that gcc didn't like =3, so it
> > should not have been used.
> 
> The flag actually needs a recent gcc 4.3 snapshot (it's
> a new feature the gcc developers added especially for the
> kernel :), so if this didn't work it would fail on the vast 
> majority of systems.
> 
> Somehow it doesn't? At least here it compiles fine.
> 
> I notice the final comma is missing, Mel does it work
> when you change the line to 
> 
> cflags-y += $(call cc-option,-mpreferred-stack-boundary=3,)  
> 

No but that is hardly a suprise as it's looking like -m64 is the way
forward.

> If not please run
> gcc -O2 -mpreferred-stack-boundary=2 -S -xc /dev/null -o x.o 
> echo $?
> 
> What does the echo output?
> 

Repeating really but;

elm3b6:~# gcc -O2 -mpreferred-stack-boundary=2 -S -xc /dev/null -o x.o ; echo $?
0
elm3b6:~# gcc -m64 -O2 -mpreferred-stack-boundary=2 -S -xc /dev/null -o x.o ; echo $?
/dev/null:1: error: -mpreferred-stack-boundary=2 is not between 4 and 12
1


-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

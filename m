Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbZBVAWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbZBVAWc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 19:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZBVAWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 19:22:24 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:50368 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbZBVAWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 19:22:23 -0500
Date: Sun, 22 Feb 2009 00:22:21 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Is kmemcheck currently broken on tip?
Message-ID: <20090222002221.GA25961@silver.sucs.org>
References: <20090221211908.GA6798@silver.sucs.org> <19f34abd0902211332r6fd0a1e3l3cee6c49e85f879e@mail.gmail.com> <19f34abd0902211419p4109f8bfsf987b68162b01f50@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0902211419p4109f8bfsf987b68162b01f50@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 11:19:50PM +0100, Vegard Nossum wrote:
> 2009/2/21 Vegard Nossum <vegard.nossum@gmail.com>:
> > 2009/2/21 Sitsofe Wheeler <sitsofe@yahoo.com>:
> >> Hi,
> >>
> >> I've been trying to test kmemcheck in linux-tip on my EeePC and things
> >> have been going suspiciously not so slow with little extra memory used
> >> (at least compared to the last time I used kmemcheck). While I see
> >> [    0.063412] kmemcheck: "Bugs, beware!"
> >> in dmesg, I'm not sure kmemcheck is working especially since nothing is
> >> flagged when I trigger the issue described in
> >> http://marc.info/?l=linux-kernel&m=123472656015761&w=1 ...
> >
> > Thanks for the tip! :-D I get this:
> >
> ...
> 
> > (Hm, maybe storing the unreliable stack frames wasn't such a good idea
> > at all -- all they do is fill up the space.)
> >
> 
> A different one, with more stack:

Thanks for the "turn off slub debug" tip - that was the problem.
Unfortunately I found myself flooded with so many kmemcheck warnings I
found it impossible to tell what was legit from all the spurious
messages (I even struggled to reproduce this problem with the end result
the kernel locked up entirely after outputing the contents of a
kmemtrace stack as the contents of sysfs file : ). As for the freed
parameter problem, Rusty proposed a fix for it a few days ago:
http://marc.info/?l=linux-kernel&m=123477909406088&w=1 .

-- 
Sitsofe | http://sucs.org/~sits/

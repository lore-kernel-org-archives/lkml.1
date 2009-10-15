Return-Path: <linux-kernel-owner+w=401wt.eu-S1762952AbZJOTRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762952AbZJOTRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762938AbZJOTR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:17:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38443 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762933AbZJOTR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:17:29 -0400
Date: Thu, 15 Oct 2009 21:16:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: david@lang.hm
Cc: Greg KH <gregkh@suse.de>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: removing existing working drivers via staging
Message-ID: <20091015191641.GB19467@elte.hu>
References: <alpine.DEB.2.00.0910142213590.22169@asgard.lang.hm> <200910151942.40259.bzolnier@gmail.com> <20091015174932.GA3595@suse.de> <200910152020.13080.bzolnier@gmail.com> <20091015184656.GA29858@suse.de> <alpine.DEB.2.00.0910151200100.22169@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910151200100.22169@asgard.lang.hm>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* david@lang.hm <david@lang.hm> wrote:

>> But a driver in staging still has to be able to build, api changes 
>> are not able to be ignored in it.
>
> a driver in staging will be able to build, but a driver that was 
> removed after 6-9 months that a user discovered the removal of a year 
> later when they upgraded to a new distro release (say a normal ubuntu 
> release after staying on the old one for the 18 month support period) 
> is likely to need significant work to catch up with kernel changes in 
> the meanwhile.

Where do you get the 6-9 months from? Greg said he'll wait 3 kernel 
releases. Here's the timeline of that:

 - release x
 - [A] driver moves into drivers/staging/ in the staging tree
 - release x+1
 - drivers/staging/ change gets merged in the x+2 merge window
 - release x+2 - first kernel with the driver in staging
 - release x+3
 - release x+4
 - driver gets removed in the staging tree
 - release x+5 - 3 kernel releases passed - now it's removed
 - removal propagates upstream in the x+6 merge window
 - [B] release x+6

from the decision to move it into staging there's 4 kernel releases 
during which the information is known, and 3 full kernel releases with 
the driver is actually moved, and even in the 4th cycle there's still 3 
months to undo the removal if there's objections (i.e. it's a 
regression).

This means the timeline is 4*3 = 12 months _at minimum_. In practice it 
will be more than a year - up to 1.5 years. Well within most distros ~3 
months upstream kernel update schedule.

And if a distro does not follow the upstream kernel ... that's a self 
inflicted wound and a distro problem really.

	Ingo

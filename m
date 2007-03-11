Return-Path: <linux-kernel-owner+w=401wt.eu-S933673AbXCKOdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673AbXCKOdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 10:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933675AbXCKOdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 10:33:00 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:38850 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933673AbXCKOc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 10:32:58 -0400
Date: Sun, 11 Mar 2007 09:32:39 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
In-reply-to: <1173613149.6927.29.camel@Homer.simpson.net>
To: linux-kernel@vger.kernel.org
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Message-id: <200703111032.40296.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703111457.17624.kernel@kolivas.org>
 <1173613149.6927.29.camel@Homer.simpson.net>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 March 2007, Mike Galbraith wrote:
>Hi Con,
>
>On Sun, 2007-03-11 at 14:57 +1100, Con Kolivas wrote:
>> What follows this email is a patch series for the latest version of
>> the RSDL cpu scheduler (ie v0.29). I have addressed all bugs that I am
>> able to reproduce in this version so if some people would be kind
>> enough to test if there are any hidden bugs or oops lurking, it would
>> be nice to know in anticipation of putting this back in -mm. Thanks.
>>
>> Full patch for 2.6.21-rc3-mm2:
>> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2-rsdl-0
>>.29.patch
>
>I'm seeing a cpu distribution problem running this on my P4 box.
>
>Scenario:
>listening to music collection (mp3) via Amarok.  Enable Amarok
>visualization gforce, and size such that X and gforce each use ~50% cpu.
>Start rip/encode of new CD with grip/lame encoder.  Lame is set to use
>both cpus, at nice 5.  Once the encoders start, they receive
>considerable more cpu than nice 0 X/Gforce, taking ~120% and leaving the
>remaining 80% for X/Gforce and Amarok (when it updates it's ~12k entry
>database) to squabble over.
>
>With 2.6.21-rc3,  X/Gforce maintain their ~50% cpu (remain smooth), and
>the encoders (100%cpu bound) get whats left when Amarok isn't eating it.
>
>I plunked the above patch into plain 2.6.21-rc3 and retested to
>eliminate other mm tree differences, and it's repeatable.  The nice 5
>cpu hogs always receive considerably more that the nice 0 sleepers.
>
>	-Mike

Just to comment, I've been running one of the patches between 20-ck1 and 
this latest one, which is building as I type, but I also run gkrellm 
here, version 2.2.9.

Since I have been running this middle of this series patch, something is 
killing gkrellm about once a day, and there is nothing in the logs to 
indicate a problem.  I see a blink out of the corner of my eye, and its 
gone.  And it always starts right back up from a kmenu click.

No idea if anyone else is experiencing this or not.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
You scratch my tape, and I'll scratch yours.

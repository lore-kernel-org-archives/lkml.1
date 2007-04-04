Return-Path: <linux-kernel-owner+w=401wt.eu-S2992968AbXDDPn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992968AbXDDPn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992974AbXDDPn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:43:58 -0400
Received: from gw.goop.org ([64.81.55.164]:59878 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992968AbXDDPn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:43:57 -0400
Message-ID: <4613C7AB.5020509@goop.org>
Date: Wed, 04 Apr 2007 08:43:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 04/17] Add pagetable accessors to pack and unpack pagetable
 entries
References: <20070402055652.610711908@goop.org> <20070402055704.278590661@goop.org> <200704020812.18320.ak@suse.de> <46136F25.7030907@goop.org> <20070404095745.GA16726@elte.hu>
In-Reply-To: <20070404095745.GA16726@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> the main metric we are interested in is the overhead for people who just 
> want to run the non-patched native kernel that has CONFIG_PARAVIRT 
> enabled (99%+ of the users at the moment), so the delta is:
>
>  null:              +12.0%
>  null IO:            +7.5%
>  stat:        within noise
>  open/close:  within noise
>  TCP:                ~5.0%
>  signal install:      2.0%
>  signal handle:       4.7%
>  fork:                2.7%
>  exec:                3.6%
>  shell:               3.6%
>   
Hm, I don't think you can get this much precision out of these numbers. 
I noticed larger variations from boot-to-boot running the same test.

> this is not 'barely measurable' but 'BLOODY LARGE' overhead.

Yes.  Fortunately there's a noticable difference between native and
unpatched paravirt, because it shows all the effort we put into patching
is worthwhile.

>> paravirt, patching
>> ezr       Linux 2.6.21- 1000 0.25 0.53 31.8 34.4 10.1 1.04 5.44 730. 1583 4600
>> ezr       Linux 2.6.21- 1000 0.26 0.55 32.1 35.2 13.3 1.03 5.48 748. 1589 4606
>> ezr       Linux 2.6.21- 1000 0.26 0.54 32.0 34.9 14.1 1.04 5.43 752. 1606 4647
>>     
>
> i guess this pretty much makes the case for patching ...
>   

Right, that's why there's patching.


    J

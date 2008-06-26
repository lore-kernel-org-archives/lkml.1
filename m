Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbYFZJAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbYFZJAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYFZJAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:00:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:51286 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYFZJAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:00:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RvB16tIksTQZhVGdTLWWUdCTV6IW+l4WJqoaBa8HAxyyonMkhjihf5uf0h5nbewOA3
         YDTSxtVXO833ixakYfH/07h3vuJ4AT3KJfcrhsneV8w8AHl8i9gLtdXjeZhijvCrS7Es
         Vgovj+UiDaibSk6g54TJcY0bexYueu+d+XSlA=
Message-ID: <19f34abd0806260200r40b46012q9bb4ba8783e8d935@mail.gmail.com>
Date: Thu, 26 Jun 2008 11:00:10 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: v2.6.26-rc7: BUG: unable to handle kernel NULL pointer dereference
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Mike Travis" <travis@sgi.com>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org,
       "Gautham R Shenoy" <ego@in.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <20080625191535.e6e60432.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080622125633.GA8166@damson.getinternet.no>
	 <200806231326.11328.rusty@rustcorp.com.au> <485FD644.80208@sgi.com>
	 <200806241136.52430.rusty@rustcorp.com.au>
	 <1214294783.25608.75.camel@ymzhang>
	 <1214441979.25608.86.camel@ymzhang>
	 <20080625191535.e6e60432.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 4:15 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> Could.  But arch/x86/kernel/smpboot.c is an x86-tree file.  I'd expect
> the x86 maintainers would like a usable changelog and a Tested-by: (if
> indeed Vegard tested it).

Hi,

I had the patch (on top of v2.6.26-rc8) in testing for a couple of
hours now, but like I expected, the APIC error is really hard to
reproduce. So I fear that we never hit the failure case in the first
place. On the other hand... I hit a number of (other?) problems:

1. Spontaneous reboot. This could have been the APIC error thing, I
have no way to know. I've never seen this before.
2. NULL pointer dereference in pick_next_task_fair(). Not new.
3. NULL pointer dereference in page_cgroup_zoneinfo. Never seen this
before (see screenshot #1).
4. Page fault in I'm guessing configure_kgdbts() during boot. Never
seen this before either (screenshot #2).

So even though I'm inclined to believe the patch is correct, I will
not ack it or claim successful test coverage.

The screenshots:

#1: http://www.kernel.org/pub/linux/kernel/people/vegard/kernels/20080626/DSCF3017.JPG
#2: http://www.kernel.org/pub/linux/kernel/people/vegard/kernels/20080626/DSCF3018.JPG


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

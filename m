Return-Path: <linux-kernel-owner+w=401wt.eu-S1758490AbZBNE6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbZBNE6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 23:58:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZBNE5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 23:57:52 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:22860 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbZBNE5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 23:57:51 -0500
X-IronPort-AV: E=Sophos;i="4.38,205,1233550800"; 
   d="scan'208";a="82856166"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [Uclinux-dist-devel] [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux (repost)
Date: Fri, 13 Feb 2009 23:58:35 -0500
User-Agent: KMail/1.9.5
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
References: <20090211185203.GA29852@Krystal> <20090212200249.GG6759@linux.vnet.ibm.com> <alpine.LFD.2.00.0902121210120.3099@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902121210120.3099@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902132358.36112.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 14 Feb 2009 04:57:49.0941 (UTC) FILETIME=[C924DA50:01C98E60]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 12 Feb 2009 15:13, Linus Torvalds pondered:
> On Thu, 12 Feb 2009, Paul E. McKenney wrote:
> > And, now that you mention it, I have heard rumors that other CPU 
> > families can violate cache coherence in some circumstances.
> 
> I personally suspect that the BF pseudo-SMP code is just broken, and
> that it likely has tons of subtle bugs and races - because we _do_ depend
> on cache coherency at least for accessing objects next to each other.

I felt similarly, however after using it, testing it, beating the crap out of 
it for while, and only finding a few niggly bugs which were corrected - it 
appears to be as stable as any other Linux kernel I have used on embedded 
hardware (which means rock solid).

There are a few people shipping it in their products today - so at least the 
stablily was also good enough for them.

If you have any other test suggestions which might expose the corner cases 
that normal use / LTP /  would not - I'm happy to try it out. The problem 
is - as Mike stated - since we do limit applications to one core at a time - 
multi-threading userspace isn't really interesting a problem.

As for the claim of "broken" hardware - I don't think that is true -- the 
hardware works as designed, as advertised. It was just never architected to 
run a SMP operating system. While you could claim that we are trying to force 
fit (SMP) something where it doesn't belong (non-cache coherence system), it 
is us that are "broken" - not the hardware :)

-Robin

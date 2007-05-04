Return-Path: <linux-kernel-owner+w=401wt.eu-S1767682AbXEDFMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767682AbXEDFMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 01:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767680AbXEDFMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 01:12:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51848 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767663AbXEDFMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 01:12:09 -0400
Date: Thu, 3 May 2007 22:12:06 -0700
From: Paul Jackson <pj@sgi.com>
To: "Ken Chen" <kenchen@google.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, agl@us.ibm.com,
       hermes@gibson.dropbear.id.au, wli@holomorphy.com, clameter@sgi.com
Subject: Re: + per-cpuset-hugetlb-accounting-and-administration.patch added
 to -mm tree
Message-Id: <20070503221206.880b1ec8.pj@sgi.com>
In-Reply-To: <b040c32a0705032149t2a380f82t8145c1d0f8f6736@mail.gmail.com>
References: <200705040104.l4414YFR026322@shell0.pdx.osdl.net>
	<20070503183821.b75e8f57.pj@sgi.com>
	<b040c32a0705032149t2a380f82t8145c1d0f8f6736@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ken wrote:
> If this is odd, do you have any suggestions for alternative?

No, I don't.  Sorry.

It's a touchy problem, and I'm not enough of an expert to know what the
right tradeoffs are in this matter.

I agree with your point that if you realize what's going on, namely
that what cpuset the task reading meminfo is in affects the HugePages
values that are read, then one can use the interface easily enough.

... how about:

 1) don't change the existing HugePages_* values - keep them
    system-wide, and

 2) adding two new values, by such names as:

	Current_Cpuset_HugePages_Total:    0
	Current_Cpuset_HugePages_Free:     0

That's certainly an uglier proposal than yours ;).  But at least it
seems clearer, and doesn't make incompatible changes to what's there.

It does require user level code change to actually benefit from the
new values, whereas your patch sort of sneaks them in, on the assumption
that the majority of reads of these values would really prefer getting
the cpuset relative totals instead.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401

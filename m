Return-Path: <linux-kernel-owner+w=401wt.eu-S936878AbXHNW0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936878AbXHNW0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936545AbXHNWXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:23:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936271AbXHNWXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:23:42 -0400
Message-ID: <46C22AE8.80901@redhat.com>
Date: Tue, 14 Aug 2007 18:21:28 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: "Luck, Tony" <tony.luck@intel.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH 10/23] make atomic_read() and atomic_set() behavior consistent
 on ia64
References: <46C03885.7000109@redhat.com> <20070813112334.GJ24018@shell.boston.redhat.com> <617E1C2C70743745A92448908E030B2A0229FD89@scsmsx411.amr.corp.intel.com> <46C1F917.1070008@redhat.com> <617E1C2C70743745A92448908E030B2A022A009A@scsmsx411.amr.corp.intel.com> <Pine.LNX.4.64.0708141509300.32420@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0708141509300.32420@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 14 Aug 2007, Luck, Tony wrote:
> 
>> I re-tried the macros ... the three warnings from mm/slub.c all result in
>> broken code ... and quite rightly too, they all come from code that does:
>>
>> 	atomic_read(&n->nr_slabs)
>>
>> But the nr_slabs field is an atomic_long_t, so we shouldn't be using
>> atomic_read().  I didn't spot these last time around because I was using
>> slab, not slub for the previous build.
> 
> Hmmmm...  Strange that this did not cause failures before on any other 
> platforms?

Prior to the patch in question, atomic_read was a macro.  I didn't use slub in 
my cursory testing.  Tony had ia64 under a microscope because of the tricky 
memory access ordering semantics of that architecture.

	-- Chris

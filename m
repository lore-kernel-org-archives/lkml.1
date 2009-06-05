Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbZFEHcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbZFEHcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 03:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbZFEHcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 03:32:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44236 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbZFEHcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 03:32:45 -0400
Message-ID: <4A28C9CD.2010208@redhat.com>
Date: Fri, 05 Jun 2009 09:31:25 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Dave McCracken <dcm@mccr.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
 kernels
References: <4A0B62F7.5030802@goop.org> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain> <200906041652.55298.dcm@mccr.org>
In-Reply-To: <200906041652.55298.dcm@mccr.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Hi,

> I think you're missing the point of Rusty's benchmark.  I see his exercise as
> "compare a kernel configured as a distro would vs a custom-built kernel
> configured for the exact target environment".  In that light, questions about
> the CONFIG options Rusty used should be based on whether most distros would
> use them in their stock kernels as opposed to how necessary they are.

Well.  The test ran on a machine with so much memory that you need 
HIGHMEM to use it all.  I think it also was SMP.  So a custom kernel for 
*that* machine would certainly include SMP and HIGHMEM ...

> What I see as the message of his benchmark is if you care about performance
> you should be customizing your kernel anyway.

Sure.  That wouldn't include turning off HIGHMEM and SMP though because 
you need them to make full use of your hardware.  While it might be 
interesting by itself to see what the overhead of these config options 
is, it is IMHO quite pointless *in the context of this discussion*.

All the other options (namespaces, audit, statistics, whatnot) are 
different:  You check whenever you want that $feature, if not you can 
turn it off.  Distros tend to have them all turned on.  So looking at 
the overhead of these config options when enabled + unused (and compare 
to the paravirt overhead) is certainly a valid thing.

cheers,
   Gerd

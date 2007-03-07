Return-Path: <linux-kernel-owner+w=401wt.eu-S1161231AbXCGCfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161231AbXCGCfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 21:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161240AbXCGCfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 21:35:41 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:57651 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161231AbXCGCfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 21:35:39 -0500
Message-ID: <45EE24FA.7090002@vmware.com>
Date: Tue, 06 Mar 2007 18:35:38 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>, Ingo Molnar <mingo@elte.hu>
CC: Gerd Hoffmann <kraxel@suse.de>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: Xen & VMI?
References: <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de> <20070306085222.GA17002@elte.hu> <20070306194612.GG19575@sequoia.sous-sol.org> <20070306203018.GA21736@elte.hu> <20070306205351.GA10574@sequoia.sous-sol.org> <20070306210334.GC26348@elte.hu> <20070306212855.GB10574@sequoia.sous-sol.org>
In-Reply-To: <20070306212855.GB10574@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> I agree that changing the interface to the low-level platform is tricky
> and less isolated.  But how does the VMI protect you from those changes?
> It simply doesn't, the changes are still necessary.  And the inflexibility
> means the tough corner cases swept under the VMI rug are more difficult
> to debug, get right, etc...
>   

I actually disagree here.  Yes, it will change over time.  VMI was 
designed to be extensible and flexible - you can omit implementation for 
any calls you don't require, and with consensus, you can add new flags, 
fields, and calls where you need them.  But VMI as it stands today is 
simply not sufficient to support the hypervisors which are here now.  
There are gaps, particularly with SMP support, which require significant 
changes to either the hypervisors, the kernel, or the VMI itself.  There 
are many reasons these gaps still exist, but most prominently, the big 
reason is that nobody wanted to use a single ABI to interface to the 
hypervisor a year ago when we first proposed the VMI interface as a 
virtualization solution for Linux.  In the end, I see no reason the 
technical issues can't be solved, but the larger questions about the 
future evolution of the interface and also some largely non-technical 
points, valid or not, have stalled the growth which we originally desired.

At this point, the question of whether to pursue a common ABI is no 
longer a technical issue, it's no longer a management or evolutionary 
issue at all.  It's a pragmatic issue about getting code that works into 
Linux today.  It's about working together using what we have as a base, 
which is paravirt-ops, to get working code to users.  We can always 
evolve the code in tree if we find a workable cross-vendor ABI that 
solves everyone's problems.  But that is neither here nor there, because 
it isn't here today.

Zach

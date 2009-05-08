Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbZEHOyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbZEHOyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbZEHOyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:54:07 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:55853 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbZEHOyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:54:04 -0400
Message-ID: <4A044786.2080508@codemonkey.ws>
Date: Fri, 08 May 2009 09:53:58 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <20090507233503.GA9103@amt.cnet> <4A043E89.90403@novell.com>
In-Reply-To: <4A043E89.90403@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>> Greg,
>>
>> I think comparison is not entirely fair.
>>     
>
> <snip>
>
> FYI: I've update the test/wiki to (hopefully) address your concerns.
>
> http://developer.novell.com/wiki/index.php/WhyHypercalls
>   

And we're now getting close to the point where the difference is 
virtually meaningless.

At .14us, in order to see 1% CPU overhead added from PIO vs HC, you need 
71429 exits.

If you have this many exits, the shear cost of the base vmexit overhead 
is going to result in about 15% CPU overhead.  To put this another way, 
if you're workload was entirely bound by vmexits (which is virtually 
impossible), then when you were saturating your CPU at 100%, only 7% of 
that is the cost of PIO exits vs. HC.

In real life workloads, if you're paying 15% overhead just to the cost 
of exits (not including the cost of heavy weight or post-exit 
processing), you're toast.  I think it's going to be very difficult to 
construct a real scenario where you'll have a measurable (i.e. > 1%) 
performance overhead from using PIO vs. HC.

And in the absence of that, I don't see the justification for adding 
additional infrastructure to Linux to support this.

The non-x86 architecture argument isn't valid because other 
architectures either 1) don't use PCI at all (s390) and are already 
using hypercalls 2) use PCI, but do not have a dedicated hypercall 
instruction (PPC emb) or 3) have PIO (ia64).

Regards,

Anthony Liguori

> Regards,
> -Greg
>
>
>   


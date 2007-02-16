Return-Path: <linux-kernel-owner+w=401wt.eu-S966219AbXBPIiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966219AbXBPIiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 03:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966224AbXBPIiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 03:38:15 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:33739 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966219AbXBPIiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 03:38:14 -0500
Message-ID: <45D56D5A.3000300@vmware.com>
Date: Fri, 16 Feb 2007 00:37:46 -0800
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@muc.de>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Ian Pratt <ian.pratt@xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 14/21] Xen-paravirt: Add XEN config options and disable
 unsupported config options.
References: <20070216022449.739760547@goop.org> <20070216022531.570154735@goop.org> <45D54BD5.8010707@vmware.com> <45D55784.1020000@goop.org> <45D562CC.8000405@vmware.com> <45D565D7.5070303@goop.org>
In-Reply-To: <45D565D7.5070303@goop.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2007 08:38:13.0764 (UTC) FILETIME=[CC045C40:01C751A5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2007 12:05 AM, Jeremy Fitzhardinge wrote:
> Dan Hecht wrote:
>> On 02/15/2007 11:04 PM, Jeremy Fitzhardinge wrote:
>>> HZ - I'm assuming dynticks will appear in the short term, and this will
>>> become moot
>> Doesn't Xen send any non-blocked domain a 100hz alarm implicitly,
>> without anyway for the guest to disable it?  I guess you'll have to
>> break kernel/hypervisor compatibility if you want dynticks? 
> 
> The timer VIRQ will generate events at a fixed 100Hz (which can be
> masked, like any other event), but you can also ask for a timer event at
> a particular time.  We do this already for tickless idle.
> 
>     J
> 

Hmm?  I thought the periodic timer and one-shot timer both generate the 
same VIRQ.  So, how can you mask one without masking the other?

The tickless idle works since the block hypercall disables the periodic 
timer.  But for dynticks (aka NO_HZ), you'll need to mask the periodic 
timer (even for a running vcpu), while keeping the one-shot timer 
unmasked.  I don't think Xen provides an interface to do that.

Dan

Return-Path: <linux-kernel-owner+w=401wt.eu-S1765033AbXF1Twl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765033AbXF1Twl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 15:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759206AbXF1Twd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 15:52:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760123AbXF1Twc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 15:52:32 -0400
Message-ID: <46841175.8070901@redhat.com>
Date: Thu, 28 Jun 2007 15:52:21 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Loic Prylli <loic@myri.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MTRR: Fix race causing set_mtrr to go into infinite loop
References: <468035BC.9080008@myri.com> <46803C1D.2040009@redhat.com> <200706260034.41940.ak@suse.de>
In-Reply-To: <200706260034.41940.ak@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2007 06:34 PM, Andi Kleen wrote:
> On Tuesday 26 June 2007 00:05:17 Chuck Ebbert wrote:
>> On 06/25/2007 05:38 PM, Loic Prylli wrote:
>>
>> [cc: Andi]
>>
>>> Processors synchronization in set_mtrr requires the .gate field
>>> to be set after .count field is properly initialized. Without an explicit
>>> barrier, the compiler was reordering those memory stores. That was sometimes
>>> causing a processor (in ipi_handler) to see the .gate change and
>>> decrement .count before the latter is set by set_mtrr() (which
>>> then hangs in a infinite loop with irqs disabled).
> 
> Hmm, perhaps we should just put the smp_wmb into atomic_set().
> Near all other atomic operations have memory barriers too. I think
> that would be the better fix.

Can we get something merged before 2.6.22-final?

The original patch seems okay...

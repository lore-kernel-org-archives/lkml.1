Return-Path: <linux-kernel-owner+w=401wt.eu-S932070AbXBNAAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbXBNAAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932072AbXBNAAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:00:19 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:43672 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932070AbXBNAAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:00:18 -0500
Message-ID: <45D250BA.7010104@vmware.com>
Date: Tue, 13 Feb 2007 15:58:50 -0800
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Ian Pratt <ian.pratt@xensource.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 14/21] Xen-paravirt: Add XEN config options and disable
 unsupported config options.
References: <20070213221729.772002682@goop.org> <20070213221830.542511707@goop.org> <45D24172.9020800@vmware.com> <45D249D9.80407@goop.org>
In-Reply-To: <45D249D9.80407@goop.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2007 23:59:21.0725 (UTC) FILETIME=[FB0CB2D0:01C74FCA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2007 03:29 PM, Jeremy Fitzhardinge wrote:
> Dan Hecht wrote:
>> I assume you plan to eventually get all this stuff working but just
>> want to prevent configurations that the Xen paravirt-ops isn't ready
>> for at the moment?
>>
>> Instead can you do it this way:
>>
>> config XEN
>>     depends on PARAVIRT && !PREEMPT && HZ_100 && !DOUBLEFAULT && !KEXEC
> 
> That's a bit simpler code-wise, but it does make it pretty complex to
> get everything just-so to even see the CONFIG_XEN option.
> 

Not only is it simpler code-wise, but it is more to the point... it is 
CONFIG_XEN that needs to be fixed to handle PREEMPT, KEXEC, different HZ 
values, etc.  Not the other way around.

Enabling the compile of any paravirt-ops backend shouldn't cripple the 
kernel in any way... instead, the burden should be on the xen 
paravirt-ops backend to be completed.  CONFIG_PREEMPT shouldn't care 
about which paravirt-ops are compiled in.  Instead, CONFIG_XEN is the 
one that needs !PREEMPT.

Dan

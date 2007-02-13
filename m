Return-Path: <linux-kernel-owner+w=401wt.eu-S932067AbXBMX6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbXBMX6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 18:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932070AbXBMX6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 18:58:22 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53564 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932067AbXBMX6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 18:58:21 -0500
Message-ID: <45D2509C.4070502@vmware.com>
Date: Tue, 13 Feb 2007 15:58:20 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Dan Hecht <dhecht@vmware.com>, Andrew Morton <akpm@osdl.org>,
       xen-devel@lists.xensource.com, Ian Pratt <ian.pratt@xensource.com>,
       linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
       Andi Kleen <ak@muc.de>, virtualization@lists.osdl.org
Subject: Re: [Xen-devel] Re: [patch 14/21] Xen-paravirt: Add XEN config options
 and disable unsupported config options.
References: <20070213221729.772002682@goop.org>	<20070213221830.542511707@goop.org> <45D24172.9020800@vmware.com> <45D249D9.80407@goop.org>
In-Reply-To: <45D249D9.80407@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Dan Hecht wrote:
>   
>> I assume you plan to eventually get all this stuff working but just
>> want to prevent configurations that the Xen paravirt-ops isn't ready
>> for at the moment?
>>
>> Instead can you do it this way:
>>
>> config XEN
>>     depends on PARAVIRT && !PREEMPT && HZ_100 && !DOUBLEFAULT && !KEXEC
>>     
>
> That's a bit simpler code-wise, but it does make it pretty complex to
> get everything just-so to even see the CONFIG_XEN option.
>   

Yes, but that is what you need to do to compile Xen - logically, to 
build a Xen kernel, you need to have a kernel configuration which can 
enable Xen - not limit the configuration of a kernel because Xen has 
been enabled.  This is because  with paravirt-ops, Xen compiled kernels 
may not actually run on Xen, so you can't arbitrarily drop features 
because you assume Xen is there.

One of these has an easy solution - doublefault.  You don't need to 
install the doublefault gate if you don't want it, and the hypervisor 
doesn't need to freak out if you install it, it can just ignore the gate 
entirely and claim #DF is not supported.

Zach

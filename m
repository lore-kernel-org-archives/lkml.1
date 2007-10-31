Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbXJaBi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbXJaBi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 21:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbXJaBiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 21:38:19 -0400
Received: from gw.goop.org ([64.81.55.164]:48034 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbXJaBiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 21:38:18 -0400
Message-ID: <4727DC88.2020803@goop.org>
Date: Tue, 30 Oct 2007 18:38:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: tgh <wwwwww4187@sina.com.cn>
CC: Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       lkml <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.com>
Subject: Re: [Xen-devel] [patch 30/44] xen: Add support for preemption
References: <20070716231536.937393000@xensource.com>>	<20070716232915.672717000@xensource.com>>	<4726F51C.4030709@sina.com.cn> <4727690F.4030502@goop.org> <4727D926.6050004@sina.com.cn>
In-Reply-To: <4727D926.6050004@sina.com.cn>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

tgh wrote:
> Thank for your reply
> and I still have several questions
>   
>> Yes, that's the normal mode of operation. The hypervisor will timeslice
>> multiple vcpus onto a single vcpu.
>>   
>>     
> that is ,the VM could be preempted by xen,and could xen hypervisor also
> be preempted to reschedule other vm or xen kernel thread?and are there
> the counterpart abstractions in xen for kernel thread in linux?
>   

Yes, a vcpu in Xen is the same as a task in the kernel. In the same way
the kernel multiplexes multiple tasks onto your cpu(s), Xen multiplexes
multiple vcpus onto your cpu(s). This isn't directly visible to the
guest kernel, in the same way that user processes can't generally
observe timeslicing.

>> This patch doesn't relate to that; it's whether a Xen Linux guest's
>> kernel can be preempted to reschedule processes while running under Xen.
>>   
>>     
> that is ,the patch makes the guest's kernel, rather than xen, be able to
> be preempted ,is it right?
>   

Yes. Previous to that change, kernel preemption was disabled when
compiling Xen support in.

J

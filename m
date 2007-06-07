Return-Path: <linux-kernel-owner+w=401wt.eu-S936234AbXFGFKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936234AbXFGFKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 01:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbXFGFJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 01:09:52 -0400
Received: from il.qumranet.com ([82.166.9.18]:39624 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbXFGFJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 01:09:51 -0400
Message-ID: <4667931C.8070007@qumranet.com>
Date: Thu, 07 Jun 2007 08:09:48 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: "Li, Xin B" <xin.b.li@intel.com>, kvm-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [PATCH] KVM - Fix rmode_tss_base declaration
References: <20070606191925.GA8989@c2.user-mode-linux.org> <B30DA1341B0CFA4893EF8A36B40B5C5D013A32CB@pdsmsx411.ccr.corp.intel.com> <20070607031103.GA12462@c2.user-mode-linux.org>
In-Reply-To: <20070607031103.GA12462@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Thu, 07 Jun 2007 08:09:49 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> On Thu, Jun 07, 2007 at 10:13:42AM +0800, Li, Xin B wrote:
>   
>>> -static int rmode_tss_base(struct kvm* kvm)
>>> +static unsigned long rmode_tss_base(struct kvm* kvm)
>>>       
>> Should use gpa_t instead.
>>     
>
> Right you are, I didn't notice that type.
>
>   

Some extra logic is needed on i386 with >= 4GB.  Current code will
wraparound since gfn_t is 32-bits long, but casting it to 64-bits is not
the answer since the processor will truncate it back to 32 bits (the
return value is eventually used as a long in enter_rmode()).


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.


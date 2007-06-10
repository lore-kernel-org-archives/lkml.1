Return-Path: <linux-kernel-owner+w=401wt.eu-S1762469AbXFJHg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762469AbXFJHg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 03:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758538AbXFJHgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 03:36:19 -0400
Received: from il.qumranet.com ([82.166.9.18]:36338 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761329AbXFJHgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 03:36:18 -0400
Message-ID: <466BA9E1.6040909@qumranet.com>
Date: Sun, 10 Jun 2007 10:36:01 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: "Li, Xin B" <xin.b.li@intel.com>, kvm-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [PATCH] KVM - Fix rmode_tss_base declaration
References: <20070606191925.GA8989@c2.user-mode-linux.org> <B30DA1341B0CFA4893EF8A36B40B5C5D013A32CB@pdsmsx411.ccr.corp.intel.com> <20070607031103.GA12462@c2.user-mode-linux.org> <4667931C.8070007@qumranet.com> <20070608194441.GA8169@c2.user-mode-linux.org>
In-Reply-To: <20070608194441.GA8169@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> On Thu, Jun 07, 2007 at 08:09:48AM +0300, Avi Kivity wrote:
>   
>> Some extra logic is needed on i386 with >= 4GB.  Current code will
>> wraparound since gfn_t is 32-bits long, but casting it to 64-bits is not
>> the answer since the processor will truncate it back to 32 bits (the
>> return value is eventually used as a long in enter_rmode()).
>>     
>
> Is it necessary to initialize TR in enter_rmode?  I can't see anything
> that says it has any meaning in real mode.
>
>   

VT doesn't support real mode.  kvm uses virtual-8086 mode to virtualize 
real mode.  Virtual 8086 mode does require a task state segment.

-- 
error compiling committee.c: too many arguments to function


Return-Path: <linux-kernel-owner+w=401wt.eu-S932199AbXINXAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbXINXAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 19:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757744AbXINXAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 19:00:25 -0400
Received: from gw.goop.org ([64.81.55.164]:36933 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757443AbXINXAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 19:00:24 -0400
Message-ID: <46EB1285.5050807@goop.org>
Date: Fri, 14 Sep 2007 16:00:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Nakajima, Jun" <jun.nakajima@intel.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure
References: <11897991353793-git-send-email-aliguori@us.ibm.com><46EAF4C6.8090903@goop.org> <46EAF6FC.80207@codemonkey.ws><46EAFBA0.4020503@goop.org> <46EB0136.6080105@codemonkey.ws><46EB02BA.6030909@goop.org> <46EB0657.40603@codemonkey.ws> <97D612E30E1F88419025B06CB4CF1BE10379EBF9@scsmsx412.amr.corp.intel.com>
In-Reply-To: <97D612E30E1F88419025B06CB4CF1BE10379EBF9@scsmsx412.amr.corp.intel.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nakajima, Jun wrote:
>>> one.  Start the kvm leaves at 0x40001000 or something?
>>>
>>>       
>> Yeah, that works with me.
>>     
>
> To me this is the beginning of fragmentation. Why do we need different
> and VMM-specific Linux paravirtualization for hardware-assisted
> virtualization? That would not be good for Linux.
>   

On the contrary.  Xen already has a hypercall interface, and we need to
keep supporting it.  If we were to also support a vmm-independent
interface (aka "kvm interface"), then we need to be able to do that in
parallel.  If we have a cpuid leaf clash, then its impossible to do so;
if we define the new interface to be disjoint from other current users
of cpuid, then we can support them concurrently.

    J

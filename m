Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbYJUBwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbYJUBwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 21:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYJUBwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 21:52:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38839 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbYJUBwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 21:52:46 -0400
Message-ID: <48FD35CC.10904@zytor.com>
Date: Mon, 20 Oct 2008 18:52:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Dan Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 2/3] x86: Get TSC frequency from VMware hypervisor.
References: <1224552952.2640.93.camel@alok-dev1>
In-Reply-To: <1224552952.2640.93.camel@alok-dev1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> x86: Get TSC frequency from VMware hypervisor.
> 
> From: Alok N Kataria <akataria@vmware.com>
> 
> This patch adds functions to detect if we are running under VMware.
> The current way to check if we are on VMware is following,
> #  check if "hypervisor present bit" is set, if so read the 0x40000000
>    cpuid leaf and check for "VMwareVMware" signature.
> #  if the above fails, check the DMI vendors name for "VMware" string
>    if we find one we query the VMware backdoor port to check if we are
>    under VMware.
> 
> The DMI + Backdoor check is needed for older VMware products, which
> don't implement the hypervisor signature cpuid leaf.
> Also note that since we are checking for the DMI signature the backdoor
> port would never be accessed on native hardware.
> 
> This patch also adds a hypervisor_get_tsc_freq function, instead of
> calibrating the frequency which can be error prone in virtualized
> environment, we ask the hypervisor for it. We get the frequency from
> the hypervisor by accessing the backdoor port if we are running on VMware.
> Other hypervisors too can add code to get frequency on their platform
> to this routine.
> 

I would like to see, instead of calling vmware_platform() directly in 
places like tsc.c, a hypervisor field in the CPU structure that is set 
with the rest of the CPU identification stuff.  That way we avoid ending 
up with garbage like:

if (vmware_platform() || xen_platform() || kvm_platform() ...)

	-hpa

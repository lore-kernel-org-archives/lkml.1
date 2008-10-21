Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYJUQSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYJUQSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 12:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbYJUQSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 12:18:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49017 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbYJUQSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 12:18:14 -0400
Message-ID: <48FE00A9.6010400@zytor.com>
Date: Tue, 21 Oct 2008 09:17:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 2/3] x86: Get TSC frequency from VMware hypervisor.
References: <1224552952.2640.93.camel@alok-dev1>  <48FD35CC.10904@zytor.com> <1224605779.6161.9.camel@alok-dev1>
In-Reply-To: <1224605779.6161.9.camel@alok-dev1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> 
> Hi hpa,
> 
> Do you mean we should have a x86_hyper_vendor field in cpuinfo_x86 ? 
> Even with that, i think we will have to differentiate between each of
> the hypervisors, as each of the hypervisor implementation differs in how
> they provide the TSC frequency. 
> 
> So we would end up with code like,
> 	if (boot_cpu.x86_hyper_vendor == VMWARE)
> 		get_frequency_vmware_way();
> 	if (boot_cpu.x86_hyper_vendor == XXX)
> 		get_frequency_XXX_way();
> 
> I agree that having a field in the cpu structure will make sure that we
> don't end up calling vmware_platform multiple times, but does it help in
> this particular situation ?
> 
> Let me know if you meant something else.
> 

That's exactly what I mean.  I want the detection centralized, and no, 
with only one user it doesn't make much difference, but there won't be 
just one user.

	-hpa

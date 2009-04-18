Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbZDRPyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbZDRPyx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 11:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbZDRPyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 11:54:43 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:63703 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbZDRPym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 11:54:42 -0400
Message-ID: <49E9F7BE.4090904@codemonkey.ws>
Date: Sat, 18 Apr 2009 10:54:38 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] Add MCE support to KVM
References: <1239953345.6842.3.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1239953345.6842.3.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> The related MSRs are emulated. MCE capability is exported via
> extension KVM_CAP_MCE and ioctl KVM_X86_GET_MCE_CAP_SUPPORTED. A new
> vcpu ioctl command KVM_X86_SETUP_MCE is used to setup MCE emulation
> such as the mcg_cap. MCE is injected via vcpu ioctl command
> KVM_X86_SET_MCE. Extended machine-check state (MCG_EXT_P) and CMCI are
> not simulated.
>   

Maybe I'm missing something, but couldn't this be implemented entirely 
within userspace?  There's nothing VT/SVM specific about this.  If the 
issue is setting these MSRs from userspace via KVM_SET_MSRS isn't 
enough, perhaps we should add userspace MSR handling.

Also, if you implement the MSR logic in userspace, it's pretty simple to 
make it work in the non-TCG case which will be a requirement for 
upstream merging.

Regards,

Anthony LIguori


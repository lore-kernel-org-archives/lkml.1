Return-Path: <linux-kernel-owner+w=401wt.eu-S932354AbXCEUm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbXCEUm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932368AbXCEUm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:42:26 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:60264 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932354AbXCEUmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:42:25 -0500
Message-ID: <45EC80B1.8030901@vmware.com>
Date: Mon, 05 Mar 2007 12:42:25 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       virtualization <virtualization@lists.osdl.org>
Subject: Re: [patch] paravirt: VDSO page is essential
References: <20070305120631.GA14105@elte.hu> <1173101297.26165.39.camel@localhost.localdomain> <20070305143437.GF22829@bingen.suse.de> <45EC796D.5050705@vmware.com> <20070305201957.GA733@elte.hu>
In-Reply-To: <20070305201957.GA733@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> there's no need to disable the VDSO for old userspace ...
>   

Well, apart from the obvious question to which nobody actually knows the 
answer, (how many people run old user space that required 
CONFIG_COMPAT_VDSO), what do you think of reversing the boot option?

vdso=enabled (default - turn on VDSO on normal boots)
vdso=disabled (turn off VDSO unconditionally)
[vdso=compat] (default for COMPAT_VDSO - keep VDSO only when mapped at 
compat location.  Note the option is not required to be implemented 
because it is logically implied from vdso=enabled && COMPAT_VDSO and the 
default boot behavior)
vdso=force (keep VDSO even when moved to a new location and COMPAT_VDSO 
is enabled).

In our case, installing VMware tools in the guest would then detect if 
userspace supports VDSO or if it requires COMPAT_VDSO and would then set 
boot parameters for the kernel appropriately.  And the native boot and 
kvm paravirt-ops boot are completely unaffected.

Zach

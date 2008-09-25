Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYIYEzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYIYEzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 00:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYIYEyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 00:54:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45393 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbYIYEyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 00:54:53 -0400
Message-ID: <48DB198C.1090207@zytor.com>
Date: Wed, 24 Sep 2008 21:54:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Yan Li <elliot.li.tech@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
References: <48D12490.5010003@zytor.com> <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com> <20080925022325.GA14390@kroah.com> <20080925024748.GG21049@yantp.cn.ibm.com> <20080925025550.GA15249@kroah.com>
In-Reply-To: <20080925025550.GA15249@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 
> Well, having a config option like this isn't the way to go as it will be
> forced on for all distros and users anyway.
> 
> A simple cpuid test is the easier way to do this, that's what the
> userspace tools do, if it's really needed in the kernel.  But hopefully,
> such things shouldn't be needed within the kernel as it's not Linux's
> fault that the hypervisor has bugs in it :)
> 
> We wouldn't be wanting to work around bugs in Microsoft's hypervisor,
> would we?
> 

We pretty much have to, just as we have to work around bugs in, say, 
AMD's microcode.  We have avoided it so far, but it's gotten to a 
breaking point, and rather than having ad hoc hacks scattered all over 
the place I want a centralized test site setting a single global variable.

Unfortunately, hypervisor vendors haven't adopted a uniform detection 
scheme (CPUID level 0x40000000 is sometimes mentioned as a 
pseudo-standard, but it's not universal, and not all virtualization 
solutions even can override CPUID.)

	-hpa

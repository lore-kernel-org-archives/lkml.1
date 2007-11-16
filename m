Return-Path: <linux-kernel-owner+w=401wt.eu-S934176AbXKPW7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176AbXKPW7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 17:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760159AbXKPW6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 17:58:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43095 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161AbXKPW6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 17:58:51 -0500
Message-ID: <473E209A.7080806@zytor.com>
Date: Fri, 16 Nov 2007 14:58:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Andreas Herrmann <aherrman@arcor.de>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Kconfig: ARCH=x86 causes wrong utsname.machine
References: <20071116111446.GA16968@devil> <20071116123747.GA12086@devil> <473DB52F.2040703@zytor.com> <20071116221535.GA1810@uranus.ravnborg.org>
In-Reply-To: <20071116221535.GA1810@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Fri, Nov 16, 2007 at 07:20:15AM -0800, H. Peter Anvin wrote:
>> Andreas Herrmann wrote:
>>> The new ARCH=x86 kernel build causes weired machine strings on 32-bit.
>>> For a cross-compiled kernel I have
>>>
>>> 	 $ uname -m
>>> 	 x66_64
>>>
>>> For a kernel natively built on a 32 bit machine I have
>>>
>>> 	$ uname -m  
>>> 	x66
>>>
>>> Looking at the sources, I think that utsname->machine was initially
>>> set as "x86_64" and "x86", respectively.
>>> But in arch/x86/kernel/cpu/bugs.c in check_bugs() the second character
>>> is set to '6' on my K7.
>>>
>>> I think the right solution for that problem is to use "x86_64" as the
>>> machine name for 64-bit and to keep the old "i[3456]86" strings for
>>> 32-bit kernels.
>> Absolutely.  This would be userspace-visible ABI breakage.
> 
> Any good suggestions here???
> UTS_MACHINE is set in top-level Makefile and if we specify
> make ARCH=x86
> we do not know if i386 or x86_&4 is correct until the configuration
> has been read.
> 
> Should we report a "make ARCH=x86" as uname -m == x86??
> 

That would break 5 years of a stable ABI.  I don't think that is even 
remotely feasible.

	-hpa

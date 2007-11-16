Return-Path: <linux-kernel-owner+w=401wt.eu-S933147AbXKPPUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147AbXKPPUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 10:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbXKPPUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 10:20:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44183 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbXKPPUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 10:20:31 -0500
Message-ID: <473DB52F.2040703@zytor.com>
Date: Fri, 16 Nov 2007 07:20:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andreas Herrmann <aherrman@arcor.de>
CC: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Kconfig: ARCH=x86 causes wrong utsname.machine
References: <20071116111446.GA16968@devil> <20071116123747.GA12086@devil>
In-Reply-To: <20071116123747.GA12086@devil>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann wrote:
> The new ARCH=x86 kernel build causes weired machine strings on 32-bit.
> For a cross-compiled kernel I have
> 
> 	 $ uname -m
> 	 x66_64
> 
> For a kernel natively built on a 32 bit machine I have
> 
> 	$ uname -m  
> 	x66
> 
> Looking at the sources, I think that utsname->machine was initially
> set as "x86_64" and "x86", respectively.
> But in arch/x86/kernel/cpu/bugs.c in check_bugs() the second character
> is set to '6' on my K7.
> 
> I think the right solution for that problem is to use "x86_64" as the
> machine name for 64-bit and to keep the old "i[3456]86" strings for
> 32-bit kernels.

Absolutely.  This would be userspace-visible ABI breakage.

	-hpa

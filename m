Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbYHYLk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbYHYLk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 07:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYHYLkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 07:40:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:39013 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbYHYLkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 07:40:18 -0400
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-Id: <5430DEC7-39DB-4316-8E7E-949CA4280403@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Kevin Diggs <kevdig@hypersurf.com>
In-Reply-To: <48B28C62.2000600@hypersurf.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 1/4] Add low level PLL config register interface module
Date: Mon, 25 Aug 2008 06:40:00 -0500
References: <48B28C62.2000600@hypersurf.com>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 25, 2008, at 5:41 AM, Kevin Diggs wrote:

> This adds a small module to handle the low level details of dealing  
> with the
> PLL config register (HID1) found in the IBM 750GX. It provides 2  
> possible
> interfaces, both selectable via kernel config options. One is a  
> sysfs attribute
> and the other is a normal function API. It is called pll_if.
>
> The determination of the bus frequency is what worked on a PowerMac  
> 8600. Any
> suggestions on a more general solution are welcome.
>
> WARNING - I used some #ifdefs - Let the fur fly!
>
> My name is Kevin Diggs and I approve this patch.

This really should be split into two patches.  One for the perl script  
and one for the actual kernel code.

Scanning the actual kernel code you have a lot of #ifdef's that should  
be cleaned up:

Can't #ifdef CONFIG_PPC_750GX_DUAL_PLL_IF_SYSFS just be #ifdef  
CONFIG_SYSFS and the same for CONFIG_PPC_750GX_DUAL_PLL_IF_HRTIMER &  
CONFIG_PPC_750GX_DUAL_PLL_IF_CPU_FREQ?

#ifdef CONFIG_PPC_OF seems unnecessary as all PPC always has this set.

What's up with #define MULFIRST and the #if 0?

- k

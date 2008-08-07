Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbYHGXyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbYHGXyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 19:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYHGXyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 19:54:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51409 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbYHGXya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 19:54:30 -0400
Message-ID: <489B8A68.10900@kernel.org>
Date: Thu, 07 Aug 2008 16:51:04 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Zachary Amsden <zach@vmware.com>, Alok Kataria <akataria@vmware.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
References: <1218136365.23770.52.camel@alok-dev1>	 <489B6710.9000604@kernel.org> <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com> <489B836A.3050209@goop.org> <489B84EF.6050009@kernel.org> <489B8948.6060003@goop.org>
In-Reply-To: <489B8948.6060003@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> The fixmap area should never have been made movable.  It's utter 
>> braindamage.
> 
> Shrug.  It's been like that for a couple of years now.  It was one of 
> the very first paravirt-ops patches.  It wasn't controversial then, and 
> nobody seems to have noticed since.

The Linux kernel was never a paragon of perfection - it was never meant 
to be.  Just because a bit of cruft went unnoticed into the kernel 
doesn't mean we shouldn't fix it.

>> Given the x86 architecture, it's inevitable that PV will want to 
>> reserve address space at the top of memory, and therefore the fixmap 
>> area needs to be moved out of that space.
> 
> OK.  But there's a few places where the code uses FIXADDR_TOP to mean 
> "top of kernel address space", so we'd need to come up with a proper 
> symbol for that.

I suggest KERNEL_TOP.

	-hpa


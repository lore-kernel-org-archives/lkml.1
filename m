Return-Path: <linux-kernel-owner+w=401wt.eu-S1758361AbYHGWRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbYHGWRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 18:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbYHGWRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:17:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58142 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbYHGWRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:17:38 -0400
Message-ID: <489B7470.5030408@kernel.org>
Date: Thu, 07 Aug 2008 15:17:20 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Alok Kataria <akataria@vmware.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
References: <1218136365.23770.52.camel@alok-dev1>	 <489B6710.9000604@kernel.org>	 <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>	 <489B6A5C.8030400@kernel.org>	 <1218145344.20178.347.camel@bodhitayantram.eng.vmware.com>	 <489B6E83.7000202@kernel.org> <1218146154.20178.352.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1218146154.20178.352.camel@bodhitayantram.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> 
>> Realistically speaking, any (virtual) machine which does *not* have a
>> full complement of lowmem (i.e. less than 896 MB in the common case)
>> will not suffer significatly from losing a few megabytes of address space.
> 
> Yes, the reason to make the fixmap moveable is to allow as much address
> space as possible for big memory (physical) machines.
> 

That being said, the fixmap area being movable more than kind of defeats 
a major point of the fixmap area; the addresses in it are no longer fixed.

The only way I can see around that, though, is to move the 1:1 mapping 
base up by 2/4 MB (for PAE/no PAE, respectively) and put the fixmap area 
there.  Kind of sucks, but would be doable.

	-hpa

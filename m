Return-Path: <linux-kernel-owner+w=401wt.eu-S1761549AbZE1AxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761549AbZE1AxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 20:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757646AbZE1AxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 20:53:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53183 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792AbZE1AxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 20:53:11 -0400
Message-ID: <4A1DE067.9090408@jp.fujitsu.com>
Date: Thu, 28 May 2009 09:52:55 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] x86: MCE: Fix for mce_panic_timeout
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>	<347567c2ace55b336b1a43a67323ff8b86b80243.1243381848.git.ak@linux.intel.com>	<3e29698799ad2c02429613323897a6e61a0a7d01.1243381848.git.ak@linux.intel.com>	<34082fc262bae2f910f1a940622173445aea72cd.1243381848.git.ak@linux.intel.com>	<c3a768c37edad55939c6f9391001fb95e658ffe6.1243381848.git.ak@linux.intel.com>	<37501061dc5d5581fefcaff92c2606e39cc61913.1243381848.git.ak@linux.intel.com>	<10e478c24139e29e7e74529edd694858ec2fb7ea.1243381848.git.ak@linux.intel.com>	<a541b2bc620d04dd777acd27a37f564ec757fe8b.1243381848.git.ak@linux.intel.com>	<abfc8311c5aff38314860d82db449c6c62e9e34d.1243381848.git.ak@linux.intel.com>	<b55d8c3d2842ee10f4b06f17cc2658f81b4f7b	4e.1243381848.git.ak@linux.intel.com>	<7efad2e5492abb8f94577a81c2ca397a968064d7.1243381848.git.ak@linux.intel.com>	<0f7e10122c48b7988b1676be5e7fc75f2c561215.1243381848.git.ak@linux.intel.com	> <4A1CC21A.10301@jp.fujitsu.com> <874ov6oo3t.fsf@basil.nowhere.org>
In-Reply-To: <874ov6oo3t.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> writes:
>>  - In case of panic_timeout > 0 and mce_bootlog == 0.
>>    System should reboot after panic, but it doesn't on mce panic because
>>    current mce code overwrite panic_timeout to 0.
> 
> Nope, with bootlog==0 it should _not_ automatically reboot on panic.
> Automatic rebooting makes mainly sense with boot logging, otherwise
> you will likely lose the information. Or at least the kernel 
> cannot know if you lose information or not so it has to err on 
> the safe side.

Users already know they might lose the information about the panic
if panic_timeout > 0.  It is same on all kind of panic.

> I changed it now to only override with panic_timeout == 0,
> as in the user didn't set anything,
> that's probably the most sensible semantics anyways.

It's OK with me.
The logic in this patch also seems good.

But...

> v2: Only force panic timeout when it's shorter (H.Seto)
> v3: Only panic when there is no earlier timeout or it's not zero
> (based on comment H.Seto)

"Only panic when ..." ?
I could not cache the meaning of this changelog.


Thanks,
H.Seto


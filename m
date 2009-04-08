Return-Path: <linux-kernel-owner+w=401wt.eu-S1763898AbZDHKGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763898AbZDHKGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758915AbZDHKGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:06:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36106 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758812AbZDHKGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:06:05 -0400
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: ying.huang@intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] [3/4] x86: MCE: Improve mce_get_rip
From: Andi Kleen <andi@firstfloor.org>
References: <20090407506.675031434@firstfloor.org>
	<20090407150656.43E161D046D@basil.firstfloor.org>
	<49DC5D11.4060505@jp.fujitsu.com>
Date: Wed, 08 Apr 2009 12:06:02 +0200
In-Reply-To: <49DC5D11.4060505@jp.fujitsu.com> (Hidetoshi Seto's message of "Wed, 08 Apr 2009 17:15:13 +0900")
Message-ID: <87eiw3a29h.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> writes:

> Andi Kleen wrote:
>> From: Huang Ying <ying.huang@intel.com>
>> 
>> Return rip/cs if MCG_STATUS_EIPV is set in mce_get_rip(). Remain m->cs
>> if RIP is read from rip_msr.
>
> It means we use "Error IP" as "Return IP" if RIPV=0 but EIPV=1 ...?
> Sounds strange.

It's not return IP, but "reported IP" in this case.

> Why this "forcing EIPV=1" still required?
> I think remaining this line will make something wrong.

Yes it's wrong. I'm dropping this in a later patch.
BTW current CPUs don't support this MSR anyways, it was a P4 only feature.

>

> I guess it would make much sense if we stop mixing RIP and EIP and rename
> the mce_get_rip() to mce_get_eip(), and the rip_msr to eip_msr too.

Ok fair enough.  I admit the code was always a bit dubious.

> And then it would be acceptable if we print RIP with "!INEXACT!" annotation
> instead of printing precise EIP in case of RIPV=0 but EIPV=1.

Please send a patch to do all that.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

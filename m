Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbZJ1PDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbZJ1PDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 11:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbZJ1PDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 11:03:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:39921 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339AbZJ1PDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 11:03:04 -0400
Message-ID: <4AE85D28.90809@kernel.org>
Date: Wed, 28 Oct 2009 16:03:04 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jes Sorensen <jes@sgi.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] ia64/sn: fix percpu warnings
References: <20091014163445.f0441473.sfr@canb.auug.org.au>	 <20091014151003.0ef42973.randy.dunlap@oracle.com>	 <4AD67C05.2030201@kernel.org> <12c511ca0910261124p64f2ad5emc88d00b9957482b3@mail.gmail.com> <57C9024A16AD2D4C97DC78E552063EA3E345953E@orsmsx505.amr.corp.intel.com>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3E345953E@orsmsx505.amr.corp.intel.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Luck, Tony wrote:
>> WARNING: "per_cpu____sn_cnodeid_to_nasid" [drivers/misc/sgi-xp/xpc.ko] has no CRC!
> 
> Note that this warning goes away if I fix the mismatch declaration so
> that we have:
> 
> DECLARE_PER_CPU(short, __sn_cnodeide_to_nasid[MAX_COMPACT_NODES]);
> in arch.h
> 
> and
> 
> DEFINE_PER_CPU(short, __sn_cnodeide_to_nasid[MAX_COMPACT_NODES]);
> in setup.c

Umm... the correct correct declaration and definition would be

DECLARE_PER_CPU(short [MAX_COMPACT_NODES], __sn_cnodeide_to_nasid);

and

DEFINE_PER_CPU(short [MAX_COMPACT_NODES], __sn_cnodeide_to_nasid);

So that the first part contains full type.  Doing it the other way
might cause problems if the __weak trick is turned on.

Thanks.

-- 
tejun

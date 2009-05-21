Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbZEUAiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbZEUAiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbZEUAiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:38:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:13481 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247AbZEUAiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:38:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,224,1241420400"; 
   d="scan'208";a="145210756"
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap
 allocator
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "JBeulich@novell.com" <JBeulich@novell.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel-owner@vger.kernel.org" 
	<linux-kernel-owner@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A149B89.3010104@kernel.org>
References: <1242305390-21958-1-git-send-email-tj@kernel.org>
	 <1242436626.27006.8623.camel@localhost.localdomain>
	 <4A0ED8D8.2010303@kernel.org>
	 <1242500964.27006.8636.camel@localhost.localdomain>
	 <4A0F672A.3000309@kernel.org>
	 <1242674444.27006.8691.camel@localhost.localdomain>
	 <4A11B9E7.8010707@zytor.com>
	 <1242680835.27006.8734.camel@localhost.localdomain>
	 <4A120B47.8060200@kernel.org>
	 <1242860470.27006.10106.camel@localhost.localdomain>
	 <4A149B89.3010104@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 20 May 2009 17:36:03 -0700
Message-Id: <1242866163.27006.10125.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-20 at 17:08 -0700, Tejun Heo wrote:
> Heh... the problem is that unless I understand what you're trying to
> achieve (and vice-versa), our discussion is likely to be riddled with
> confusions, and currently either you're misunderstanding the whole
> thing or I'm being slow (not too unusual :-).  It would be nice to
> determine which way it is.

At the start of this, I was trying to see a way where we can use large
page mappings for percpu areas and at the same time, avoid the
complexity of cpa() that we are adding in this patchset. So, I was going
down the path of exploiting your bootmem allocation for the first percpu
chunk (as kernel identity mappings are already taken care by cpa()).

> The dynamic onlining will probably use 4k pages so, yeah, it won't
> have the alias issues but that's not the issue here, right?  You can
> already avoid aliasing that way by simply using 4k allocator from the
> get-go.

But now that I learnt about dynamic online allocation, can we avoid the
complexity brought by this patchset, by simply using 4k allocator from
get-go.

i.e., can we drop this remap pageattr handling patchset and simply use
4k mapping for now? And move to dynamic allocation at a later point.

This will simplify quite a bit of code.

thanks,
suresh


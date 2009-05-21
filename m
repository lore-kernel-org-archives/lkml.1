Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbZEUAIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbZEUAIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZEUAHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:07:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:55219 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbZEUAHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:07:52 -0400
Message-ID: <4A149B89.3010104@kernel.org>
Date: Thu, 21 May 2009 09:08:41 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: suresh.b.siddha@intel.com
CC: "H. Peter Anvin" <hpa@zytor.com>,
       "JBeulich@novell.com" <JBeulich@novell.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel-owner@vger.kernel.org" 
	<linux-kernel-owner@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap allocator
References: <1242305390-21958-1-git-send-email-tj@kernel.org>	 <1242436626.27006.8623.camel@localhost.localdomain>	 <4A0ED8D8.2010303@kernel.org>	 <1242500964.27006.8636.camel@localhost.localdomain>	 <4A0F672A.3000309@kernel.org>	 <1242674444.27006.8691.camel@localhost.localdomain>	 <4A11B9E7.8010707@zytor.com>	 <1242680835.27006.8734.camel@localhost.localdomain>	 <4A120B47.8060200@kernel.org> <1242860470.27006.10106.camel@localhost.localdomain>
In-Reply-To: <1242860470.27006.10106.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 00:07:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Suresh Siddha wrote:
>> Hmmm... I can't really follow what you're suggesting.  Can you please
>> explain it in more detailed way?
> 
> Ok. Before I make another attempt walking that hill :)

Heh... the problem is that unless I understand what you're trying to
achieve (and vice-versa), our discussion is likely to be riddled with
confusions, and currently either you're misunderstanding the whole
thing or I'm being slow (not too unusual :-).  It would be nice to
determine which way it is.

> I was talking to Peter and it seems there are some requests to change
> the first percpu unit allocation for each possible cpu using bootmem
> allocator, to allocating the corresponding unit at the cpu online time.
> 
> Do you have plans to change this?

Yeap, once the remaining archs are converted, that's the next stop.
With recently posted patchset, only three remain - sparc64, powerpc64
and sparc64.  Davem is working on sparc64.  I'm planning on doing
powerpc64.  ia64 is a bit tricky as it already remaps percpu areas but
I'm sure we'll find a way around it.  After that, yeap, the dynamic
online thing.

> If we do this allocation during the corresponding cpu online time
> and don't end up using big pages, then also we avoid all these
> aliasing issues...

The dynamic onlining will probably use 4k pages so, yeah, it won't
have the alias issues but that's not the issue here, right?  You can
already avoid aliasing that way by simply using 4k allocator from the
get-go.

Thanks.

-- 
tejun

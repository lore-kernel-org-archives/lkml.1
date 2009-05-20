Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbZETIWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbZETIWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZETIVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:21:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:59825 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbZETIVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:21:47 -0400
Message-ID: <4A13BCE1.7050209@kernel.org>
Date: Wed, 20 May 2009 17:18:41 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux@arm.linux.org.uk,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, takata@linux-m32r.org,
       geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org,
       kyle@mcmartin.ca, benh@kernel.crashing.org, paulus@samba.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, lethal@linux-sh.org,
       davem@davemloft.net, jdike@addtoit.com, chris@zankel.net,
       rusty@rustcorp.com.au
Subject: Re: [PATCH 2/7] linker script: throw away .discard section
References: <1242805059-18338-1-git-send-email-tj@kernel.org>	 <1242805059-18338-3-git-send-email-tj@kernel.org> <8bd0f97a0905200059pea3469do9e9b1a7644517558@mail.gmail.com> <4A13B9EA.4030801@kernel.org>
In-Reply-To: <4A13B9EA.4030801@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 20 May 2009 08:19:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Mike Frysinger wrote:
>> On Wed, May 20, 2009 at 03:37, Tejun Heo wrote:
>>> x86 throws away .discard section but no other archs do.  Also,
>>> .discard is not thrown away while linking modules.  Make every arch
>>> and module linking throw it away.  This will be used to define dummy
>>> variables for percpu declarations and definitions.
>> seems like a good time to introduce a common DISCARD define to
>> include/asm-generic/vmlinux.lds.h.  considering multiple /DISCARD/
>> entries are allowed in a linker script, the define should be pretty
>> straightforward:
>> #define DISCARDS \
>>     /DISCARD/ : { \
>>         EXIT_TEXT \
>>         EXIT_DATA \
>>         *(.exitcall.exit) \
>>         *(.discard) \
>>     }
> 
> Hmmm... indeed, that would be nice.  I'll update the patch.

Eh... handling of EXIT_TEXT and DATA aren't uniform across archs.  I
think I'll leave the /DISCARD/ unification for the next time.

Thanks.

-- 
tejun

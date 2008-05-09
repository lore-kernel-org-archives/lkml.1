Return-Path: <linux-kernel-owner+w=401wt.eu-S1758947AbYEIWOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbYEIWOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 18:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYEIWOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 18:14:44 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:40519 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752295AbYEIWOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 18:14:43 -0400
Date: Sat, 10 May 2008 00:14:41 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [ASYNC_TX] don't include <asm/> headers
Message-ID: <20080509221441.GA1672@Chamillionaire.breakpoint.cc>
References: <20080426154801.GA18712@Chamillionaire.breakpoint.cc> <e9c3a7c20804292342o38ca485by4dec2d137fefcac5@mail.gmail.com> <20080509083912.GA32396@Chamillionaire.breakpoint.cc> <e9c3a7c20805091155w741fc8eai761fa232bb27dedf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <e9c3a7c20805091155w741fc8eai761fa232bb27dedf@mail.gmail.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dan Williams | 2008-05-09 11:55:25 [-0700]:

>On Fri, May 9, 2008 at 1:39 AM, Sebastian Siewior <lkml@ml.breakpoint.cc> wrote:
>> * Dan Williams | 2008-04-29 23:42:46 [-0700]:
>>
>>
>>  >Thanks, I'll push this out for testing in -next / -mm.
>>  I can't see this in current -next and I can't remember that I got an
>>  email from Andrew.
>>
>
>Hi Sebastian,
Hi Dan,

>Yes I had put this in the background for awhile due to other issues.
No problem. If you queue this up for another two weeks than I have no
problem with it. I just wanted to make sure that you did not lose it :)

>I fixed up a few merge conflicts so that it will apply against the
>current tree; however, the patch causes these new warnings:
>
>include/asm/xor_32.h:513: warning: 'xor_block_pII_mmx' defined but not used
>include/asm/xor_32.h:521: warning: 'xor_block_p5_mmx' defined but not used
>include/asm/xor_32.h:853: warning: 'xor_block_pIII_sse' defined but not used
>include/asm-generic/xor.h:680: warning: 'xor_block_8regs' defined but not used
>include/asm-generic/xor.h:688: warning: 'xor_block_32regs' defined but not used
>include/asm-generic/xor.h:696: warning: 'xor_block_8regs_p' defined but not used
>include/asm-generic/xor.h:704: warning: 'xor_block_32regs_p' defined
>but not used
>
>It is not immediately clear why?
I'm not sure why I haven't seen this myself. crypto/xor.c is the only
user of those defines but linux/raid/xor.h is also included by
async_xor.c which does not use xor_block_pII_mmx & friends. The best
thing would be probably _not_ to merge those two header files like I did
but keep them separate. Maybe we could move this define directly into
crypto/xor.c since it is the only user?

Sebastian

Return-Path: <linux-kernel-owner+w=401wt.eu-S936968AbYEUTuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936968AbYEUTuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760156AbYEUTt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:49:59 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:53321 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759836AbYEUTt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:49:58 -0400
Date: Wed, 21 May 2008 12:44:07 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
In-Reply-To: <1211378410.8297.192.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0805211238440.5706@t2.domain.actdsltmp>
References: <1211316025-29069-1-git-send-email-tpiepho@freescale.com> 
 <1211318219.8297.177.camel@pasglop>  <Pine.LNX.4.64.0805201425250.7453@t2.domain.actdsltmp>
 <1211378410.8297.192.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Benjamin Herrenschmidt wrote:
>> Depends on what you define as "necessary".  It's seem clear that I/O accessors
>> _no not_ need to be strictly ordered with respect to normal memory accesses,
>> by what's defined in memory-barriers.txt.  So if by "necessary" you mean what
>> the Linux standard for I/O accessors requires (and what other archs provide),
>> then yes, they have the necessary ordering guarantees.
>>
>> But, if you want them to be strictly ordered w.r.t to normal memory, that's
>> not the case.
>
> They should be.

Someone should update memory-barriers.txt, because it doesn't say that, and
all I/O accessors for all the arches, because none of them are.

>> Here's a quick hack I stuck in a driver to test.  compile with -save-temps and
>> check the resulting asm.  gcc will do the optimization I described above.
>>
>> static void __iomem *baz = (void*)0x1234;
>> static struct bar {
>>      u32 bar[256];
>> } bar;
>>
>> void foo(void) {
>>      bar.bar[0] = 44;
>>      out_be32(baz+100, 200);
>>      bar.bar[0] = 45;
>>      out_be32(baz+101, 201);
>> }
>
> Have you removed -fno-strict-aliasing ? Just don't do that.

No, it's compiled with a normal kernel build, which includes
-fno-strict-aliasing.

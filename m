Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbYFLG4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbYFLG4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbYFLGzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:55:55 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:39174 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753683AbYFLGzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:55:54 -0400
Message-ID: <4850C861.108@linux.vnet.ibm.com>
Date: Thu, 12 Jun 2008 12:25:29 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080505)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] 2.6.26-rc5-mm2 - kernel BUG at arch/x86/kernel/setup.c:388!
References: <20080609223145.5c9a2878.akpm@linux-foundation.org> <485011DF.9050606@linux.vnet.ibm.com>  <1213208897.20475.19.camel@nimitz> <19f34abd0806111137t4291b9fkb66951aa8f4d456f@mail.gmail.com>
In-Reply-To: <19f34abd0806111137t4291b9fkb66951aa8f4d456f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> On 6/11/08, Dave Hansen <dave@linux.vnet.ibm.com> wrote:
>> On Wed, 2008-06-11 at 23:26 +0530, Kamalesh Babulal wrote:
>>  > Hi Andrew,
>>  >
>>  > The 2.6.26-rc5-mm2 kernel panic's, while booting up on the x86_64
>>  > box with the attached .config file.
>>
>>
>> Just to save everyone the trouble, it looks like this is a new BUG_ON().
>>  ﻿
>>  http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc5/2.6.26-rc5-mm2/broken-out/fix-x86_64-splat.patch
>>
>>  The machine in question is a single-node machine, but with
>>  CONFIG_NUMA=y.
>>
> 
> Yes. Sorry, I already responded in a separate e-mail (see below), but
> that obviously missed all the Ccs. So here it goes again...:
> 
> I'm betting
> 
> commit a953e4597abd51b74c99e0e3b7074532a60fd031
> Author: Mike Travis <travis@sgi.com>
> Date:   Mon May 12 21:21:12 2008 +0200
> 
>     sched: replace MAX_NUMNODES with nr_node_ids in kernel/sched.c
> 
> will fix this if it's not in -mm2 already.
> 
> The BUG() is simply there to prevent silent corruption. Mike already
> has a patch that changes it to a WARN(), but it obviously didn't get
> through (either)...
> 
> 
> Vegard
Hi,

Thanks, the patch fixes the kernel oops.

> 
> 
> On 6/11/08, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> On 6/9/08, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>>  > Hi Andrew,
>>  >
>>  > The 2.6.26-rc5-mm2 kernel panic's, while booting up on the x86_64
>>  > box with the attached .config file.
>>
>>  (Please apologize for the strange way of replying to this message. It
>>  seems that LKML gave up delivering to my address, so I'm currently
>>  reading off lkml.org.)
>>
>>  This should already be fixed, but Andrew refused to apply the patch
>>  before releasing the -mm1 (and -mm2 apparently). I'm attaching the
>>  patch, can you see if it helps?
>>
>>  Thanks.
>>
>>
>>  Vegard
> 


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

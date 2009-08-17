Return-Path: <linux-kernel-owner+w=401wt.eu-S1751580AbZHQNBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbZHQNBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 09:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbZHQNBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 09:01:21 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:54247 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZHQNBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 09:01:21 -0400
Message-ID: <4A8954F8.7040602@colorfullife.com>
Date: Mon, 17 Aug 2009 15:02:48 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [patch 4a/4] ipc: sem optimise simple operations
References: <200908141946.n7EJkh7B018160@mail.q-ag.de> <20090815045237.GC19195@wotan.suse.de> <4A86899A.6050502@colorfullife.com> <20090815103820.GC8954@wotan.suse.de> <4A86ABF0.2070207@colorfullife.com> <20090815144908.GA30951@wotan.suse.de> <4A86E30E.8030208@colorfullife.com> <20090816103127.GB8644@wotan.suse.de> <4A87ED93.5060104@colorfullife.com> <20090817064446.GD9962@wotan.suse.de>
In-Reply-To: <20090817064446.GD9962@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2009 08:44 AM, Nick Piggin wrote:
> OK, well let's just get something in.
>    
Good, I would propose the that the following 7 patches should be merged:

http://lkml.org/lkml/2009/8/11/59
http://lkml.org/lkml/2009/8/11/9
http://lkml.org/lkml/2009/8/11/14
http://lkml.org/lkml/2009/8/15/163
http://lkml.org/lkml/2009/8/15/164
http://lkml.org/lkml/2009/8/15/167
http://lkml.org/lkml/2009/8/15/168

Nick: is that ok from your point of view?

> That said, I'm not too unhappy with your version if you feel strongly
> about it.
I would prefer it:
We simply don't know if a wait-for-zero list, only for single sop operations, is a step in the right direction.

Postgres uses single sop operations with just +-1 on one semaphore.
You wrote that your SAP workload also uses +-1.
According to google codesearch, apache, mozilla, mpich all use +-1.

Thus: Who uses single sop, wait for zero?
I'm just afraid that we optimize for the wrong case.

--
	Manfred


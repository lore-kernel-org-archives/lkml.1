Return-Path: <linux-kernel-owner+w=401wt.eu-S1760353AbYF0QHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353AbYF0QHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756095AbYF0QGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:06:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57581 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918AbYF0QGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:06:52 -0400
Date: Fri, 27 Jun 2008 18:06:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <npiggin@suse.de>, Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Stephen Tweedie <sct@redhat.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for
	64-bit Xen support
Message-ID: <20080627160625.GA29488@elte.hu>
References: <patchbomb.1214367536@localhost> <20080625084253.GA11524@elte.hu> <20080625152212.GA3442@elte.hu> <4862A6A9.1030109@goop.org> <20080626105722.GA12640@elte.hu> <20080626105818.GA13805@elte.hu> <4863A8E6.1010807@goop.org> <20080627155656.GA19180@elte.hu> <48650F02.5080200@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48650F02.5080200@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> i'm testing on multiple systems in parallel, each is running randconfig 
>> kernels. One 64-bit system found a build bug, the other one found a 
>> boot crash.
>>
>> This can happen if certain configs build fine (but crash), certain 
>> configs dont even build. Each system does a random walk of the config 
>> space.
>
> Yes, but the URL for both the crash and the build failure pointed to 
> the same config.  Is one of them a mistake?

yeah, i guess so. Right now i only ran into the build failure so there's 
hope :) Here's a config that fails to build for sure:

  http://redhat.com/~mingo/misc/config-Fri_Jun_27_17_54_32_CEST_2008.bad

note, on 32-bit there's a yet unfixed initrd corruption bug i've 
bisected back to:

| 510be56adc4bb9fb229637a8e89268d987263614 is first bad commit
| commit 510be56adc4bb9fb229637a8e89268d987263614
| Author: Yinghai Lu <yhlu.kernel@gmail.com>
| Date:   Tue Jun 24 04:10:47 2008 -0700
|
|    x86: introduce init_memory_mapping for 32bit

so if you see something like that it's probably not a bug introduced by 
your changes. (and maybe you'll see why the above commit is buggy, i 
havent figured it out yet)

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761449AbZFOUr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761449AbZFOUr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 16:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761950AbZFOUrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 16:47:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47487 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764091AbZFOUru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 16:47:50 -0400
Message-ID: <4A36B238.5020203@zytor.com>
Date: Mon, 15 Jun 2009 13:42:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       efault@gmx.de, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain support
 to use NMI-safe methods
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <alpine.LFD.2.01.0906151125320.6276@localhost.localdomain> <20090615183649.GA16999@elte.hu> <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain> <4A36ABB5.1040109@goop.org> <alpine.LFD.2.01.0906151326170.6276@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906151326170.6276@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 15 Jun 2009, Jeremy Fitzhardinge wrote:
>> We have to restore the usermode %gs somewhere...
> 
> None of this is useful for user-mode return _anyway_, since you have to 
> restore %cs/%ss too. At that point, you have to use iret.
> 

cs/ss you could potentially restore with sysret/sysexit, at least for
the common case.  Of course, this means more cases...

	-hpa


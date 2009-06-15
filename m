Return-Path: <linux-kernel-owner+w=401wt.eu-S932187AbZFOUSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbZFOUSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 16:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZFOUSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 16:18:25 -0400
Received: from claw.goop.org ([74.207.240.146]:56864 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbZFOUSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 16:18:24 -0400
Message-ID: <4A36AC87.7020200@goop.org>
Date: Mon, 15 Jun 2009 13:18:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       npiggin@suse.de, tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain support
 to use NMI-safe methods
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org>	 <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain>	 <20090615171845.GA7664@elte.hu>	 <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain>	 <4A369508.2090707@zytor.com> <20090615184858.GD6520@Krystal>	 <1245091917.6741.185.camel@laptop> <20090615185907.GF6520@Krystal>	 <20090615190321.GA11641@elte.hu>  <20090615190759.GA12778@elte.hu> <1245093011.6741.213.camel@laptop> <4A369F3F.5060600@redhat.com>
In-Reply-To: <4A369F3F.5060600@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/09 12:21, Avi Kivity wrote:
> You can read cr2 on nmi entry and nmi exit, and only write it if it 
> has changed (if it turns out that writing cr2 is expensive; ISTR that 
> it isn't).
>

Writing the real cr2 is expensive, but it may be cheap to write the 
virtual cr2 in a vmx context.  Or something.

     J

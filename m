Return-Path: <linux-kernel-owner+w=401wt.eu-S1752378AbYGaKrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbYGaKrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYGaKrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:47:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51242 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbYGaKrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:47:23 -0400
Date: Thu, 31 Jul 2008 12:46:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Jan Beulich <jbeulich@novell.com>, Andi Kleen <andi@firstfloor.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] i386: improve double fault handling
Message-ID: <20080731104651.GJ488@elte.hu>
References: <4880A912.76E4.0078.0@novell.com> <4881263B.7060700@zytor.com> <48846B02.76E4.0078.0@novell.com> <20080721110510.GC10782@elte.hu> <4885CEFE.76E4.0078.0@novell.com> <20080728134252.GI5515@elte.hu> <488E4166.5070304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488E4166.5070304@redhat.com>
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


* Chuck Ebbert <cebbert@redhat.com> wrote:

> Ingo Molnar wrote:
>>
>> All CPUs hitting a double fault simultaneously and corrupting each  
>> others' kernel stack is a theoretical possibility - but is handling it  
>> worth the complexity? It appears to me that a lock plus a short stub  
>> function that takes the lock (with no stack usage) would handle that  
>> much better.
>
> That can't happen now because the TSS gets marked busy so we will get 
> a triple fault instead. One thing we might want to do in the current 
> code is unset the busy flag after handling the fault and before we 
> start looping at the end of the handler so we can handle another fault 
> later.

that would be a nice improvement.

	Ingo

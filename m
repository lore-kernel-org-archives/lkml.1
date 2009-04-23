Return-Path: <linux-kernel-owner+w=401wt.eu-S1759764AbZDWIJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759764AbZDWIJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 04:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757286AbZDWIHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 04:07:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49138 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759098AbZDWIHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 04:07:33 -0400
Date: Thu, 23 Apr 2009 10:06:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       mark.langsdorf@amd.com, arekm@maven.pl,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [patch 2/2] x86 amd fix cmpxchg read acquire barrier
Message-ID: <20090423080645.GF22606@elte.hu>
References: <20090422201852.092307236@polymtl.ca> <20090422202453.829846363@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422202453.829846363@polymtl.ca>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> " // Opteron Rev E has a bug in which on very rare occasions a locked
>   // instruction doesn't act as a read-acquire barrier if followed by a
>   // non-locked read-modify-write instruction.  Rev F has this bug in 
>   // pre-release versions, but not in versions released to customers,
>   // so we test only for Rev E, which is family 15, model 32..63 inclusive.

Dunno. The fix looks a bit intrusive (emits a NOP even on good 
CPUs). Also, the text above says "not in versions released to 
customers".

So unless there's an official erratum or reports in the field (not 
from early prototype systems shipped to developers) i'd not rush to 
apply it, just yet.

	Ingo

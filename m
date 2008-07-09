Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbYGIT2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbYGIT2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYGIT2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:28:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59641 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbYGIT2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:28:42 -0400
Date: Wed, 9 Jul 2008 21:28:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
Message-ID: <20080709192822.GB4804@elte.hu>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709165129.292635000@polaris-admin.engr.sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

>   * x86_64: Rebase per cpu variables to zero
> 
>     Take advantage of the zero-based per cpu area provided above. Then 
>     we can directly use the x86_32 percpu operations. x86_32 offsets 
>     %fs by __per_cpu_start. x86_64 has %gs pointing directly to the 
>     pda and the per cpu area thereby allowing access to the pda with 
>     the x86_64 pda operations and access to the per cpu variables 
>     using x86_32 percpu operations.

hm, have the binutils (or gcc) problems with this been resolved?

If common binutils versions miscompile the kernel with this feature then 
i guess we cannot just unconditionally enable it. (My hope is that it's 
not necessarily a binutils bug but some broken assumption of the kernel 
somewhere.)

	Ingo

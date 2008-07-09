Return-Path: <linux-kernel-owner+w=401wt.eu-S1755677AbYGIUPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbYGIUPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbYGIUPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:15:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57766 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbYGIUPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:15:18 -0400
Date: Wed, 9 Jul 2008 22:15:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
Message-ID: <20080709201501.GF14009@elte.hu>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <m1abgqzv3g.fsf@frodo.ebiederm.org> <48751A0D.5020107@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48751A0D.5020107@goop.org>
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

>> Further -fstack-protector-all only seems to detect against buffer 
>> overflows and thus corruption of the stack.  Not stack overflows.  So 
>> it doesn't appear especially useful.
>
> It's a bit useful.  But at the cost of preventing a pile of more 
> useful unification work, not to mention making all access to per-cpu 
> variables more expensive.

well, stackprotector is near zero maintenance trouble. It mostly binds 
in places that are fundamentally non-unifiable anyway. (nobody is going 
to unify the assembly code in switch_to())

i had zero-based percpu problems (early crashes) with a 4.2.3 gcc that 
had --fstack-protect compiled out, so there's no connection there.

In its fixed form in tip/core/stackprotector it can catch the splice 
exploit which makes it quite a bit useful. It would be rather silly to 
not offer that feature.

	Ingo

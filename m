Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbYGITmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbYGITmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYGITl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:41:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56396 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbYGITl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:41:56 -0400
Date: Wed, 9 Jul 2008 21:41:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
Message-ID: <20080709194136.GD4804@elte.hu>
References: <4874F7D9.5060607@linux-foundation.org> <4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org> <487502BD.2020206@goop.org> <487504A8.5040000@linux-foundation.org> <487507E7.6010102@goop.org> <48750945.8000201@linux-foundation.org> <48750C6C.5090606@goop.org> <48750D96.7030407@linux-foundation.org> <4875123F.1070504@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4875123F.1070504@goop.org>
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

>> What is remaining is the task to rename
>>
>> 	pda.Y -> Z
>>
>> in order to make variable references the same under both arches. 
>> Presumably the Z is the corresponding 32 bit variable. There are 
>> likely a number of cases where the transformation is trivial if we 
>> just identify the corresponding 32 bit equivalent.
>
> Yes, I understand that, but it's still pointless churn.  The 
> intermediate step is no improvement over what was there before, and 
> isn't any closer to the desired final result.
>
> Once you've made the pda a percpu variable, and redefined all the 
> X_pda macros in terms of x86_X_percpu, then there's no need to touch 
> all the usage sites until you're *actually* going to unify something.  
> Touching them all just because you find "X_pda" unsightly doesn't help 
> anyone.  Ideally every site you touch will remove a #ifdef 
> CONFIG_X86_64, or make two as-yet unified pieces of code closer to 
> unification.

that makes sense. Does everyone agree on #1-#2-#3 and then gradual 
elimination of most pda members (without going through an intermediate 
renaming of pda members) being the way to go?

	Ingo

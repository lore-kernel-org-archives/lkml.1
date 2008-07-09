Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbYGIVFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbYGIVFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYGIVFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:05:34 -0400
Received: from relay1.sgi.com ([192.48.171.29]:56763 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752696AbYGIVFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:05:33 -0400
Message-ID: <4875281C.4060806@sgi.com>
Date: Wed, 09 Jul 2008 14:05:32 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <4874F7D9.5060607@linux-foundation.org> <4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org> <487502BD.2020206@goop.org> <487504A8.5040000@linux-foundation.org> <487507E7.6010102@goop.org> <48750945.8000201@linux-foundation.org> <48750C6C.5090606@goop.org> <48750D96.7030407@linux-foundation.org> <4875123F.1070504@goop.org> <20080709194136.GD4804@elte.hu>
In-Reply-To: <20080709194136.GD4804@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
>>> What is remaining is the task to rename
>>>
>>> 	pda.Y -> Z
>>>
>>> in order to make variable references the same under both arches. 
>>> Presumably the Z is the corresponding 32 bit variable. There are 
>>> likely a number of cases where the transformation is trivial if we 
>>> just identify the corresponding 32 bit equivalent.
>> Yes, I understand that, but it's still pointless churn.  The 
>> intermediate step is no improvement over what was there before, and 
>> isn't any closer to the desired final result.
>>
>> Once you've made the pda a percpu variable, and redefined all the 
>> X_pda macros in terms of x86_X_percpu, then there's no need to touch 
>> all the usage sites until you're *actually* going to unify something.  
>> Touching them all just because you find "X_pda" unsightly doesn't help 
>> anyone.  Ideally every site you touch will remove a #ifdef 
>> CONFIG_X86_64, or make two as-yet unified pieces of code closer to 
>> unification.
> 
> that makes sense. Does everyone agree on #1-#2-#3 and then gradual 
> elimination of most pda members (without going through an intermediate 
> renaming of pda members) being the way to go?
> 
> 	Ingo


This is fine with me... not much more work required to go "all the way"... ;-)

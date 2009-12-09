Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbZLISTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbZLISTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbZLISTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:19:40 -0500
Received: from claw.goop.org ([74.207.240.146]:33041 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbZLISTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:19:39 -0500
Message-ID: <4B1FEA3F.7090300@goop.org>
Date: Wed, 09 Dec 2009 10:19:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091125 Fedora/3.0-3.12.rc1.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickens <hugh@veritas.com>
Subject: Re: [GIT PULL] x86/paravirt for v2.6.33
References: <20091203210913.GA24351@elte.hu> <alpine.LFD.2.00.0912081329460.3560@localhost.localdomain> <20091209073632.GD8187@elte.hu>
In-Reply-To: <20091209073632.GD8187@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/09 23:36, Ingo Molnar wrote:
>> The old version that actually passed the stack frame was better. Why
>> pick the inferior version?
>>      
> Yeah, agreed. I missed that detail.
>    

Which detail is that?  The whole patch? ;)

> Jeremy, mind sending a patch that updates this code to use the less
> obfuscated 32-bit version, not the 64-bit version? (a delta patch
> against tip:master would be nice, as there's a fair amount of testing in
> the unification change itself already, which we dont want to discard.)
>    

Sure.

But I'm not sure I understand the objection to task_pt_regs(); is it 
considered deprecated?   This patch received quite a lot of discussion 
with no mention of it.  Should we consider all its uses as suspect?

Would it be better to have something similar which just returns a 
pointer to the saved [re]flags, since that's all we care about?  That 
should be easier to make robust against

     J

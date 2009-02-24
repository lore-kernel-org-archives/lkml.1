Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbZBXQCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbZBXQCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 11:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbZBXQCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 11:02:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48148 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbZBXQCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 11:02:38 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Tejun Heo <tj@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jeremy@goop.org, cpw@sgi.com
Subject: Re: [patch] x86: optimize __pa() to be linear again on 64-bit x86
From: Andi Kleen <andi@firstfloor.org>
References: <1234958676-27618-1-git-send-email-tj@kernel.org>
	<20090223101741.GP9582@elte.hu> <20090223133804.GA20468@elte.hu>
	<200902240108.54892.nickpiggin@yahoo.com.au>
	<20090223145358.GB3377@elte.hu>
Date: Tue, 24 Feb 2009 17:00:57 +0100
In-Reply-To: <20090223145358.GB3377@elte.hu> (Ingo Molnar's message of "Mon, 23 Feb 2009 15:53:58 +0100")
Message-ID: <87zlgb3juu.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> Yeah, we can do this complete conversion.
>
> I'll clean it up some more. I think the best representation of 
> this will be via a virt_to_sym() and sym_to_virt() space. That 
> makes it really clear when we are moving from the symbol space 
> to the linear space and back.
>
> That way we wont need the _slow() methods at all - we'll always 
> know whether an address is pure linear or in the symbol space.
>
> In other words, it will be even faster and even nicer ;-)

That is what the original code did (virt_to_sym was just
done through __pa_symbol), but it was sometimes tricky 
to get right andLinus wanted an unified __pa/__va
and put it out of line.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

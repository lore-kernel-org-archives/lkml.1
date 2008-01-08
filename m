Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbYAHXZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbYAHXZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYAHXY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:24:57 -0500
Received: from gw.goop.org ([64.81.55.164]:33943 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbYAHXY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:24:56 -0500
Message-ID: <478405DA.40303@goop.org>
Date: Tue, 08 Jan 2008 15:23:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
References: <patchbomb.1199829603@localhost> <20080108224244.GA3768@elte.hu> <20080108231226.GA10744@elte.hu>
In-Reply-To: <20080108231226.GA10744@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> threw this into the random test setup: it found the attached config 
> after a few iterations, which needed the fix below. (config builds and 
> boots fine with this fix)
>
> the problem was that set_pud() is used by 
> include/asm-generic/pgtable-nopud.h, to build set_pgd():
>
> #define set_pgd(pgdptr, pgdval)                 set_pud((pud_t *)(pgdptr), (pud_t) { pgdval })
>   

Oh, yeah.  That's bitten me before, but I guess I lost that part of the 
patch somewhere :(.

> it's truly a maze ... took me 10 straight minutes of staring at the code 
> to figure out where the set_pud() came from :-/
>   

It's pretty awful.  The pagetable level folding stuff is fairly deep 
into "too clever" territory, but its hard to see what better 
alternatives there are...  Dropping non-PAE support would be nice, but 
impractical given that even relatively recent chips are missing support 
for it.

> anyway, your patchset is holding up pretty good so far in testing.
>   

Great!

    J

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbYKSACw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbYKSACw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 19:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbYKSACo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 19:02:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35379 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbYKSACn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 19:02:43 -0500
Message-ID: <49235759.7070109@zytor.com>
Date: Tue, 18 Nov 2008 16:01:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jan Beulich <jbeulich@novell.com>, heukelum@fastmail.fm,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Glauber Costa <gcosta@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [RFC,v2] x86_64: save_args out of line
References: <20081117175232.GA13766@mailshack.com> <49228648.76E4.0078.0@novell.com> <20081118111633.GA21036@mailshack.com> <4922C863.76E4.0078.0@novell.com> <20081118140349.GC23479@elte.hu> <4922E4D4.76E4.0078.0@novell.com> <20081118150024.GD30358@elte.hu> <20081118225336.60FFA1544EB@magilla.localdomain> <20081118233552.GP6703@one.firstfloor.org> <20081118234511.80C4F1544F1@magilla.localdomain> <20081119000605.GQ6703@one.firstfloor.org>
In-Reply-To: <20081119000605.GQ6703@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> Hmm, but if the assembler cannot auto generate it how should the assembler
> writer know if he should use the macro or the direct instruction without
> understanding CFI?
> 
> Also what will the assembler reader do? Do they first have to understand
> CFI to understand everything? I personally would probably just
> resort to objdump -S in this situation.
> 
> I think you're saying that for the user the macros would be just
> equivalent, but if that's true they could be just auto generated 
> by the assembler. But it's obviously not, so you'll end up
> with the Linux magic asm dialect (and its maintenance disadvantages)
> and you'll still require CFI knowledge to understand/write everything 
> anyways.
> 

We already have a "Linux magic asm dialect" which require CFI knowledge. 
  Nothing can change that other than dumping the requirement that we 
have valid CFI data.  However, the current code is hard to read and easy 
to trip up on.  We can at least make it easier, especially to read -- 
and making it easier to read will help writers, too.

	-hpa

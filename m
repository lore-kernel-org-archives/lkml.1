Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbYJGXFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbYJGXFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYJGXFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:05:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46263 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbYJGXFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:05:43 -0400
Date: Wed, 8 Oct 2008 01:11:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/3] Provide rdtscll() asm/msr.h for user space
Message-ID: <20081007231149.GT20740@one.firstfloor.org>
References: <20081007143.793379346@firstfloor.org> <48EBD555.9060104@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EBD555.9060104@kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 02:32:05PM -0700, H. Peter Anvin wrote:
> I really don't think this belongs in the kernel.  It's not even a case 
> of "usable by accident" anymore, and hasn't worked for a while, so it's 
> not a matter of legacy, either.

Actually it that's not true because most distros still use relatively old kernel
includes.  It really only broke with paravirt, which especially on 64bit
is extremly new.

I think on a few of the latest distros actually break it in their
default setup, that is why I looked at fixing it (ran into this
in suse 11.0, in 10.3 it was all still ok) 

> 
> Mixing fundamentally unrelated kernel and userspace variants of the same 
> function just makes the aggregation uglier than both.

I disagree on the fundamentally unrelated. They are the same semantically
(although the paravirt entry point is misnamed, it shouldn't call
itself RDTSC)

> 
> (Also, most userspace variants I have seen have what the kernel calls 
> "rdtscll" and calls it "rdtsc".)

At least asm/msr.h has used it like this forever (2.4). 

> I would suggest writing a <sys/tsc.h> header file and submitting to the 
> glibc people, instead, or perhaps even better, start a libarch/libx86 tree.

That wouldn't work on old kernels. asm/msr.h has been the traditional 
interface for this and rdtsc has worked forever (at least dating back to 2.0)
rdtscll is a bit newer, but still in Linux terms ancient (2.4)

Also in my experience distributions are extremly slow at keeping up
with glibc, so even if this was added to glibc it would be probably
years before it would be actually usable :/ And I see about zero
point in changing a perfectly fine include name breaking everything old.

Anyways if you insist I can probably deal without
but I (and likely others) would think something nasty about you every time 
I have to cut'n'paste that code again. Do you really want to risk that? @)

-Andi

-- 
ak@linux.intel.com

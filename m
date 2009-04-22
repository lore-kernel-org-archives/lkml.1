Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbZDVVEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbZDVVEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 17:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbZDVVEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 17:04:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754416AbZDVVEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 17:04:15 -0400
Date: Wed, 22 Apr 2009 13:56:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH] X86-32: Let gcc decide whether to inline memcpy was Re:
 New x86 warning
In-Reply-To: <8763gxoz50.fsf_-_@basil.nowhere.org>
Message-ID: <alpine.LFD.2.00.0904221354320.3101@localhost.localdomain>
References: <49EEBD3C.3060009@garzik.org> <20090422070157.GA28438@elte.hu> <8763gxoz50.fsf_-_@basil.nowhere.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 22 Apr 2009, Andi Kleen wrote:
> 
> Modern gcc (and that is all that is supported now) should be able to
> generate this code on its own already.  So if you call __builtin_* it
> will  just work (that is what 64bit does) without that explicit code.

Last time we tried that, it wasn't true. Gcc wouldn't inline even trivial 
cases of constant sizes.

I do not recall what gcc version that was all about, and maybe the 
versions we now require are all modern enough that it isn't an issue, but 
I'd want somebody to actually _verify_ that the oldest version we support 
does an ok job, and doesn't do stupid things for constant-sized memcpy's.

> IMHO it's long overdue to do this for 32bit too.

With actual testing, I'll happily merge this.

		Linus

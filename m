Return-Path: <linux-kernel-owner+w=401wt.eu-S932692AbZJAOgC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692AbZJAOgC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:36:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932634AbZJAOgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:36:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932627AbZJAOgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:36:00 -0400
Date: Thu, 1 Oct 2009 07:34:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Borislav Petkov <borislav.petkov@amd.com>
cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <petkovbb@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: mce: Please revert
 22223c9b417be5fd0ab2cf9ad17eb7bd1e19f7b9
In-Reply-To: <20091001141432.GA11410@aftab>
Message-ID: <alpine.LFD.2.01.0910010731130.6996@localhost.localdomain>
References: <20090930140904.GA6150@one.firstfloor.org> <20090930194049.GA17712@liondog.tnic> <20090930204643.GA24862@elte.hu> <20090930214859.GA28638@elte.hu> <20090930223956.GE17712@liondog.tnic> <20090930230947.GA9346@elte.hu>
 <20091001141432.GA11410@aftab>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Oct 2009, Borislav Petkov wrote:
> 
> Ok, here it is, tested on two Fam10 machines here with injecting MCEs.
> The decoding code is now built-in by default (early_initcall requires
> !MODULE).

I don't think it has to require !MODULE. We could do what we do for the 
other initcalls, ie if MODULE we turn it into just a regular initcall. If 
that allows something like the EDAC MCE to be built as a module, and 
people want to, then just go ahead and add the one-liner to <linux/init.h>

Of course, if it _requires_ being loaded early for some other reason, then 
that's a different issue. But don't do it just because we don't have the

	#define early_initcall(fn)               module_init(fn)

line.

		Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbYFTTT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbYFTTT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbYFTTSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:18:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753749AbYFTTSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:18:42 -0400
Date: Fri, 20 Jun 2008 12:15:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, benh@kernel.crashing.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel <kvm-devel@lists.sourceforge.net>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Hugh Dickins <hugh@veritas.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction
 abstraction
In-Reply-To: <485BFFC4.3070902@goop.org>
Message-ID: <alpine.LFD.1.10.0806201211560.3167@woody.linux-foundation.org>
References: <1213831403.8011.24.camel@pasglop> <4859A149.9090004@goop.org> <4859A528.1010107@goop.org> <alpine.LFD.1.10.0806181723400.2907@woody.linux-foundation.org> <4859AA47.2020903@goop.org> <alpine.LFD.1.10.0806181743390.2907@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806182050470.2907@woody.linux-foundation.org> <20080619115832.GM15228@elte.hu> <alpine.LFD.1.10.0806190928100.2907@woody.linux-foundation.org> <20080619164708.GA32190@elte.hu> <20080620101028.GA23664@elte.hu> <485BFFC4.3070902@goop.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 20 Jun 2008, Jeremy Fitzhardinge wrote:
> 
> Blows up on "gcc version 3.4.4 20050314 (prerelease) (Debian 3.4.3-13)":

Yeah, I was a bit worried about that. Gcc sometimes does insane things.

We literally just tested that the asm should only _ever_ be generated with 
a constant value, but if some gcc dead-code removal thing doesn't work, it 
will then screw up and try to generate the asm even for a non-constant 
thing.

The fairly trivial fix is probably to just change the "i" to "ir", safe in 
the knowledge that any _sane_ case will never use the "r" possibility. I 
suspect even your insane case will end up then killing the bad choice 
later.

		Linus

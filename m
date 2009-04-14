Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbZDNSK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbZDNSK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbZDNSKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:10:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752436AbZDNSKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:10:44 -0400
Date: Tue, 14 Apr 2009 11:06:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: tj@kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Fix the section attribute on UP DECLARE_PER_CPU()
In-Reply-To: <15312.1239731865@redhat.com>
Message-ID: <alpine.LFD.2.00.0904141103550.18124@localhost.localdomain>
References: <alpine.LFD.2.00.0904140954160.18124@localhost.localdomain> <20090414161053.28145.1209.stgit@warthog.procyon.org.uk> <15312.1239731865@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Apr 2009, David Howells wrote:
> 
> Agreed, it would be nice.  However, x86 requires it to be declared in the
> middle of asm/percpu.h (ie: in asm-generic/percpu.h). 

Hmm. Why not move it all above the '#include <asm/percpu.h>'?

Sure, then the odd architectures (read: ia64) that actually want to 
re-define things like PER_CPU_BASE_SECTION would have to now do

	#undef PER_CPU_BASE_SECTION
	#define PER_CPU_BASE_SECTION ".data.percpu"

but wouldn't that all actually be much CLEANER than the insane crap we do 
today?

But yeah, I didn't look at all the details. It _looked_ pretty 
straightforward to just move the DEFINE/DECLARE stuff up, but there may 
well be something subtle I'm missing.

			Linus

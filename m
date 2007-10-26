Return-Path: <linux-kernel-owner+w=401wt.eu-S1764668AbXJZUjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764668AbXJZUjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbXJZUjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:39:10 -0400
Received: from mx1.suse.de ([195.135.220.2]:52801 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755608AbXJZUjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:39:09 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Bart Van Assche" <bart.vanassche@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Haley" <aph@redhat.com>
Subject: Re: Is gcc thread-unsafe?
From: Andi Kleen <andi@firstfloor.org>
References: <e2e108260710260729x4603211cgb68d7434ce1e54e9@mail.gmail.com>
	<e2e108260710260740k27210c4fu2f75d5fb31ccdccc@mail.gmail.com>
	<alpine.LFD.0.999.0710260814570.30120@woody.linux-foundation.org>
	<alpine.LFD.0.999.0710260917500.30120@woody.linux-foundation.org>
	<e2e108260710261007n118186b5geb3a48094638497f@mail.gmail.com>
	<20071026190856.18510fc4@the-village.bc.nu>
Date: Fri, 26 Oct 2007 22:39:07 +0200
In-Reply-To: <20071026190856.18510fc4@the-village.bc.nu> (Alan Cox's message of "Fri\, 26 Oct 2007 19\:08\:56 +0100")
Message-ID: <p73d4v1pq50.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
>
> You can stop the compiler but not the CPU - and some processors will
> certainly speculatively load across conditionals, reorder writes etc

The difference is that the CPU knows how to cancel most[1] side effects
of these speculative accesses (e.g. by not issuing exceptions[2] etc.). 

The compiler doesn't normally (except on some architectures with special support like IA64;
but I'm not sure gcc supports it there) 

[1] In some it can't and we've had problems with that in the past. e.g. in
a few cases speculative reads can be a problem. But we generally fix or
workaround those cases in the code.
[2] Modulo hardware bugs -- see the hall of shame in x86_64 fault.c

-Andi

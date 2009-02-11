Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbZBKSzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbZBKSzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 13:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbZBKSzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 13:55:23 -0500
Received: from gw.goop.org ([64.81.55.164]:38154 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756624AbZBKSzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 13:55:22 -0500
Message-ID: <49931F04.80605@goop.org>
Date: Wed, 11 Feb 2009 10:55:00 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86: more header untangling
References: <4991D626.5040009@goop.org> <20090211100323.GE20518@elte.hu> <49930485.3070204@goop.org> <20090211171439.GA9185@elte.hu>
In-Reply-To: <20090211171439.GA9185@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> constants can be considered data types too.

Huh, that's a pretty broad definition of "type", to the degree that's 
its fairly counter-intuitive and misleading.  But I don't care that much.

>  Small inlines are borderlines,
> they should generally not be in _types.h headers. Really, _types.h headers
> are only there to instantiate a type, to enable dependent inline methods
> to use them.
>   

In this case the inlines are the accessor functions to do the pte_t <-> 
pteval_t (un)wrapping.  They're trivial and have no dependencies apart 
from the types they're right next to.

Anyway, check out 
git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git 
x86/untangle now.  I had to merge in tip/x86/paravirt to get the 
pte_flags changes I made there, and unfortunately it didn't merge 
completely cleanly, so there's probably some spurious changes in there.  
I guess I can respin it into a clean branch.

    J

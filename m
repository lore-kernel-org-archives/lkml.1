Return-Path: <linux-kernel-owner+w=401wt.eu-S934482AbXGQTRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934482AbXGQTRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbXGQTQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:16:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57089 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753531AbXGQTQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:16:58 -0400
Date: Tue, 17 Jul 2007 12:15:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: caglar@pardus.org.tr, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [GIT PULL][RESEND #2] KVM Updates for 2.6.23-rc1
In-Reply-To: <469D1317.1050202@zytor.com>
Message-ID: <alpine.LFD.0.999.0707171212070.27353@woody.linux-foundation.org>
References: <11846910642166-git-send-email-avi@qumranet.com>
 <200707172139.09131.caglar@pardus.org.tr> <469D1317.1050202@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2007, H. Peter Anvin wrote:
>
> S.Çağlar Onur wrote:
> > 
> > If i'm not wrong X86_CMPXCHG64 depends on CONFIG_X86_PAE which depends on 
> > HIGHMEM64 and again if i'm not wrong this means distributions who wants to 
> > provide KVM must enable CONFIG_X86_PAE and CONFIG_HIGHMEM64G from now on?
> > 
> 
> X86_PAE should depend on X86_CMPXCHG64, not the other way around.

Actually, I think the *real* solution would be:

 - add a X86_HAS_CMPXCHG8B config option, and set it for the appropriate 
   CPU selection (P6 and up, or whatever the rule is)

 - make KVM depend on it

 - make KVM and HIGHMEM64 _select_ another config option, namely the 
   NEEDS_CMPXCHG8B

and then we make the cpufeatures code check the CMPXCHG bit only if the 
NEEDS_CMPXCHG8B thing is set. That gives us the best of all worlds.

Because there is no point in checking whether the CPU supports it if the 
kernel doesn't _need_ it. Especially since we know that some CPU's lie 
about it due to old NT bugs.

		Linus

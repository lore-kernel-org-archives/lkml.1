Return-Path: <linux-kernel-owner+w=401wt.eu-S935576AbXGQT1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935576AbXGQT1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759741AbXGQT1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:27:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50693 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304AbXGQT1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:27:07 -0400
Message-ID: <469D17C9.9010509@zytor.com>
Date: Tue, 17 Jul 2007 12:26:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: caglar@pardus.org.tr, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [GIT PULL][RESEND #2] KVM Updates for 2.6.23-rc1
References: <11846910642166-git-send-email-avi@qumranet.com> <200707172139.09131.caglar@pardus.org.tr> <469D1317.1050202@zytor.com> <alpine.LFD.0.999.0707171212070.27353@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707171212070.27353@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Actually, I think the *real* solution would be:
> 
>  - add a X86_HAS_CMPXCHG8B config option, and set it for the appropriate 
>    CPU selection (P6 and up, or whatever the rule is)
> 
>  - make KVM depend on it
> 
>  - make KVM and HIGHMEM64 _select_ another config option, namely the 
>    NEEDS_CMPXCHG8B
> 
> and then we make the cpufeatures code check the CMPXCHG bit only if the 
> NEEDS_CMPXCHG8B thing is set. That gives us the best of all worlds.
> 
> Because there is no point in checking whether the CPU supports it if the 
> kernel doesn't _need_ it. Especially since we know that some CPU's lie 
> about it due to old NT bugs.
> 

Yes.  This is probably also true for other CPU feature options, at least
in the abstract (i.e. it may not apply to any of the current options).

	-hpa

Return-Path: <linux-kernel-owner+w=401wt.eu-S934548AbXGQTHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934548AbXGQTHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760442AbXGQTG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:06:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52337 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759654AbXGQTG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:06:58 -0400
Message-ID: <469D1317.1050202@zytor.com>
Date: Tue, 17 Jul 2007 12:05:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: caglar@pardus.org.tr
CC: Avi Kivity <avi@qumranet.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [GIT PULL][RESEND #2] KVM Updates for 2.6.23-rc1
References: <11846910642166-git-send-email-avi@qumranet.com> <200707172139.09131.caglar@pardus.org.tr>
In-Reply-To: <200707172139.09131.caglar@pardus.org.tr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

S.Çağlar Onur wrote:
> 
> If i'm not wrong X86_CMPXCHG64 depends on CONFIG_X86_PAE which depends on 
> HIGHMEM64 and again if i'm not wrong this means distributions who wants to 
> provide KVM must enable CONFIG_X86_PAE and CONFIG_HIGHMEM64G from now on?
> 

X86_PAE should depend on X86_CMPXCHG64, not the other way around.

I asked Andi Kleen about this on IRC, and he said:

<freitag> the reason was that i didn't want to hack everybody's magic
MSRs into the old verify_cpu.S

verify_cpu.S is dead on i386 (replaced by arch/i386/boot/cpucheck.c)
which does have the flags enable MSR tweaks; it is still being used for
APs on x86-64.  However, in the meantime it should be safe to remove
this dependency from i386.

	-hpa


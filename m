Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbXBKLNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbXBKLNm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 06:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbXBKLNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 06:13:42 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36914 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbXBKLNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 06:13:41 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21 review I] [11/25] x86: default to physical mode on hotplug CPU kernels
References: <200702101250.142420000@suse.de>
	<20070210115023.D19ED13DCE@wotan.suse.de>
Date: Sun, 11 Feb 2007 04:13:02 -0700
In-Reply-To: <20070210115023.D19ED13DCE@wotan.suse.de> (Andi Kleen's message
	of "Sat, 10 Feb 2007 12:50:23 +0100 (CET)")
Message-ID: <m1vei9ymkh.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

> From: Ingo Molnar <mingo@elte.hu>
>
> Default to physical mode on hotplug CPU kernels.  Furher simplify and clean up
> the APIC initialization code.

Where is the code that the subject describes?

I have two problems here.

- I don't see anything handling the hotplug case, and forcing us to
  physical mode.
- Ingo's other patch asserts that hotplug should be made to handle
  logical deliver mode.

With logical deliver mode the experimental evidence is that the
destination cpu is a hint, and you can arrive at a cpu that is not
in your cpu mask.  Now I only saw that problem on hyperthreaded cpus
but we didn't have the code enabled long enough to see it in other
cases.

Maybe if I can finish getting irq migration back into process context,
and someone verifies that the cpu disable in the hotplug path actually
disables the cpu/hyperthread instead of sitting in a hlt loop.  We
won't have a problem.  But broadcast ipis and irqs that don't go where
you tell them to are things we need to be very careful with.

Eric

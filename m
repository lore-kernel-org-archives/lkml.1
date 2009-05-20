Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbZETIQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbZETIQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbZETIQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:16:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59592 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbZETIQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:16:27 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
From: Andi Kleen <andi@firstfloor.org>
References: <1242170864-13560-1-git-send-email-jeremy@goop.org>
	<20090513133021.GA7277@elte.hu> <4A0ADBA2.2020300@goop.org>
	<20090515182757.GA19256@elte.hu> <4A0DCC11.10307@goop.org>
	<m1my9ex818.fsf@fess.ebiederm.org> <4A0DFF78.6000501@goop.org>
	<20090515202250.0f1218ef@jbarnes-g45>
	<m1iqk1k708.fsf@fess.ebiederm.org> <4A10EAC4.9070701@goop.org>
	<20090518085902.GE10687@elte.hu> <4A11A3F8.1010202@goop.org>
Date: Wed, 20 May 2009 10:16:26 +0200
In-Reply-To: <4A11A3F8.1010202@goop.org> (Jeremy Fitzhardinge's message of "Mon, 18 May 2009 11:07:52 -0700")
Message-ID: <87tz3gnq91.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> arch/x86 already defines an mtrr_ops, which defines how to manipulate
> the MTRR registers.  There are currently several implementations of
> that interface.  In Xen the MTRR registers belong to the hypervisor,
> but it allows a privileged kernel to modify them via hypercalls. 

One part that's unclear to me in this discussion. Could you perhaps
clarify Jeremy?:

Even Dom0 is not continuous in physical memory, but mapped page by page
except for swiotlb mappings. But MTRRs are fundamentally a way 
to change attributes for large physically continous mappings. How do these
two meet?

After all when you change a MTRR for a given range of memory
linux sees as continuous it isn't necessarily in Xen.

Is this new interface only defined for swiotlb or MMIO mappings?
If yes did you check the drivers only actually set it on
swiotlb or MMIO (that seems dubious to me)?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

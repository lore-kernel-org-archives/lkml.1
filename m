Return-Path: <linux-kernel-owner+w=401wt.eu-S1757802AbYG1Txq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802AbYG1Txq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 15:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYG1Txi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 15:53:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37743 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbYG1Txh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 15:53:37 -0400
Date: Mon, 28 Jul 2008 21:53:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI/CPUIDLE: prevent setting pm_idle to NULL
Message-ID: <20080728195324.GE30344@one.firstfloor.org>
References: <alpine.LFD.1.10.0807272343480.574@apollo.tec.linutronix.de> <20080728174644.GC30344@one.firstfloor.org> <alpine.LFD.1.10.0807282107500.14925@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807282107500.14925@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem here is that the acpi/cpuidle code can be in a state where
> the _save/old variables _ARE_ NULL because they had not been
> initialized with the original pm_idle before the module is removed or
> the cst state changes. So all we have to do is to prevent pm_idle to
> be set to NULL.

It still seems wrong to me to fall back to the cpuidle idle function
instead of the earlier idle function just because cpuidle was loaded
in a weird way. 

But yes mwait_idle could be set up later after the saving state.
I suggested default_idle because it is safe, but yes it is probably
not the optimal choice.

Perhaps to solve this cleanly we really need to go to a hierarchy
of idle functions registered with priority instead of this fragile
pointer saving/restoring. 

-Andi

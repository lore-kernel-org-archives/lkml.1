Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZA3Ipy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZA3Ipy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 03:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZA3Ipj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 03:45:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52189 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbZA3Ipi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 03:45:38 -0500
Date: Fri, 30 Jan 2009 10:01:36 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: unify genapic code, unify subarchitectures, remove old subarchitecture code
Message-ID: <20090130090136.GA18453@one.firstfloor.org>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu> <87vdryw6ql.fsf@basil.nowhere.org> <eada2a070901291324t1a2dbb08hbff7b026c77d69cd@mail.gmail.com> <20090129221402.GA1984@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129221402.GA1984@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> At this point there's no technical need to kill it - it's a zero-overhead 
> thing tucked away into a single .c module in arch/x86/kernel/numaq_32.c. I 
> even consolidated most of its headers in that file, to reduce its cross 
> section.

There's still a couple of hooks in the subarch interface (even your new one) 
which are effectively NUMAQ only. These are far from zero overhead. Plus the
ugly wards in smpboot.c like the special path to wake up CPUs via NMI and
some other things. And the hacks like the special ECR access. NUMAQ is really
very very different from a normal PC and needed a lot of special code. 

Even with your changes removing NUMAQ would be a significant cleanup.

Also BTW if it hasn't been tested it's unlikely to work and
keeping code around that doesn't work doesn't seem very useful.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

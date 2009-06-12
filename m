Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbZFLP3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbZFLP3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbZFLP3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:29:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391AbZFLP3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:29:37 -0400
Date: Fri, 12 Jun 2009 08:28:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Wu Fengguang <fengguang.wu@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/5] HWPOISON: define VM_FAULT_HWPOISON to 0 when feature
 is disabled
In-Reply-To: <20090612131754.GA32105@elte.hu>
Message-ID: <alpine.LFD.2.01.0906120827020.3237@localhost.localdomain>
References: <20090611142239.192891591@intel.com> <20090611144430.414445947@intel.com> <20090612112258.GA14123@elte.hu> <20090612125741.GA6140@localhost> <20090612131754.GA32105@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Jun 2009, Ingo Molnar wrote:
> 
> This seems like trying to handle a failure mode that cannot be and 
> shouldnt be 'handled' really. If there's an 'already corrupted' page 
> then the box should go down hard and fast, and we should not risk 
> _even more user data corruption_ by trying to 'continue' in the hope 
> of having hit some 'harmless' user process that can be killed ...

No, the box should _not_ go down hard-and-fast. That's the last thing we 
should *ever* do.

We need to log it. Often at a user level (ie we want to make sure it 
actually hits syslog, possibly goes out the network, maybe pops up a 
window, whatever).

Shutting down the machine is the last thing we ever want to do. 

The whole "let's panic" mentality is a disease.

		Linus

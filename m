Return-Path: <linux-kernel-owner+w=401wt.eu-S1752761AbZCNDlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbZCNDlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 23:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbZCNDln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 23:41:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:45027 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbZCNDln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 23:41:43 -0400
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
 Breakpoint interfaces
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Stern <stern@rowland.harvard.edu>, prasad@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
In-Reply-To: <20090310172605.GA28767@elte.hu>
References: <20090310151828.GM3850@elte.hu>
	 <Pine.LNX.4.44L0.0903101244140.3979-100000@iolanthe.rowland.org>
	 <20090310172605.GA28767@elte.hu>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 14:40:33 +1100
Message-Id: <1237002033.25062.77.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 18:26 +0100, Ingo Molnar wrote:
> 
> That 'arbitrarily larg number of breakpoints' worries me. It's a 
> pretty broken concept for a 4-items resource that cannot be 
> time-shared and hence cannot be overcommitted.
> 
> Seems to me that much of the complexity of this patchset:
> 
>  28 files changed, 2439 insertions(+), 199 deletions(-)
> 
> Could be eliminated via a very simple exclusive reservation 
> mechanism.
> 
I also have some worries about the bloat of this infrastructure,
especially in the context switching code.

I would prefer the arch to be in control of the state in the task struct
and just context switch the actual HW registers at that stage.

Ben.



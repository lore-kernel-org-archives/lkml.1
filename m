Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbYIBOh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbYIBOh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 10:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYIBOht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 10:37:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53269 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbYIBOhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 10:37:48 -0400
Date: Tue, 2 Sep 2008 16:40:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/2] Don't complain about disabled irqs when the system has paniced
Message-ID: <20080902144051.GM18288@one.firstfloor.org>
References: <20080902349.573187695@firstfloor.org> <20080902134923.9A7EF3E6A01@basil.firstfloor.org> <1220365683.8609.58.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220365683.8609.58.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 04:28:03PM +0200, Peter Zijlstra wrote:
> On Tue, 2008-09-02 at 15:49 +0200, Andi Kleen wrote:
> > panic calls smp_send_stop which eventually calls smp_call_function_*.
> > smp_call_function warns about disabled interrupts. But it's legal
> > to call panic in this case. When this happens panic() prints
> > several ugly backtraces. So don't check for disabled interrupts
> > in panic state.
> 
> While it might be legal for panic to be called from such contexts, I
> understand those warnings are there to warn of deadlocks.
> 
> So with the below patch you allow panic to deadlock if I understand
> things correctly.

Please describe the deadlock exactly.  I don't think it can deadlock 
in this case. 

Besides do you prefer to not allow panic from interrupts/machine
checks etc. anymore? 

-Andi


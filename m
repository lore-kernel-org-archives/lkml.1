Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbZIAOoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbZIAOoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 10:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbZIAOoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 10:44:23 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41294 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752145AbZIAOoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 10:44:23 -0400
Subject: Re: ARM + jprobes/kretprobes SEGV/hangs/OOPS in 2.6.29 kernel
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: venki kaps <venkiece2005@gmail.com>, Nicolas Pitre <nico@cam.org>,
       "sagar.abhishek@gmail.com" <sagar.abhishek@gmail.com>,
       "jkenisto@us.ibm.com" <jkenisto@us.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "prasanna@in.ibm.com" <prasanna@in.ibm.com>
In-Reply-To: <20090901142549.GA21501@flint.arm.linux.org.uk>
References: <6d53329e0908250342g2cfb73f6v90f73c283c0d391c@mail.gmail.com>
	 <alpine.LFD.2.00.0908251333410.6044@xanadu.home>
	 <6d53329e0908302227l63420351m1005d0c76346e2ec@mail.gmail.com>
	 <6d53329e0908310311v55ef3909na0cbec756e63ccab@mail.gmail.com>
	 <6d53329e0908312355y7bd2038ds6ba8efe671d98bc9@mail.gmail.com>
	 <tnxocpu7osx.fsf@pc1117.cambridge.arm.com>
	 <20090901142549.GA21501@flint.arm.linux.org.uk>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 01 Sep 2009 15:43:59 +0100
Message-Id: <1251816239.10349.66.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Sep 2009 14:43:59.0990 (UTC) FILETIME=[A454B160:01CA2B12]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-01 at 15:25 +0100, Russell King wrote:
> On Tue, Sep 01, 2009 at 02:54:54PM +0100, Catalin Marinas wrote:
> > venki kaps <venkiece2005@gmail.com> wrote:
> > > I have found the exact problem with respect to ARM jprobes.
> > >
> > > The problem with configure i.e, CONFIG_ARM_UNWIND = y; is enabled.
> > 
> > I haven't followed the kprobes implementation for ARM but does it make
> > any assumptions about the existence of a frame pointer on the stack?
> > Enabling stack unwinding automatically disables the framepointer.
> 
> If it uses CALLER_ADDRESSx() then it won't work with unwinding enabled.
> See 5613/1 (which is pending in the devel branch.)

In addition to that, when CONFIG_FRAME_POINTER is disabled, the lr
register isn't always saved on the stack by the called function. I'm not
sure whether kretprobe_trampoline is aware of this.

-- 
Catalin


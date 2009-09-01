Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbZIAO0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbZIAO0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 10:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbZIAO0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 10:26:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47747 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955AbZIAO0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 10:26:42 -0400
Date: Tue, 1 Sep 2009 15:25:49 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: venki kaps <venkiece2005@gmail.com>, Nicolas Pitre <nico@cam.org>,
       "sagar.abhishek@gmail.com" <sagar.abhishek@gmail.com>,
       "jkenisto@us.ibm.com" <jkenisto@us.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "prasanna@in.ibm.com" <prasanna@in.ibm.com>
Subject: Re: ARM + jprobes/kretprobes SEGV/hangs/OOPS in 2.6.29 kernel
Message-ID: <20090901142549.GA21501@flint.arm.linux.org.uk>
References: <6d53329e0908250342g2cfb73f6v90f73c283c0d391c@mail.gmail.com> <alpine.LFD.2.00.0908251333410.6044@xanadu.home> <6d53329e0908302227l63420351m1005d0c76346e2ec@mail.gmail.com> <6d53329e0908310311v55ef3909na0cbec756e63ccab@mail.gmail.com> <6d53329e0908312355y7bd2038ds6ba8efe671d98bc9@mail.gmail.com> <tnxocpu7osx.fsf@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tnxocpu7osx.fsf@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 02:54:54PM +0100, Catalin Marinas wrote:
> venki kaps <venkiece2005@gmail.com> wrote:
> > I have found the exact problem with respect to ARM jprobes.
> >
> > The problem with configure i.e, CONFIG_ARM_UNWIND = y; is enabled.
> 
> I haven't followed the kprobes implementation for ARM but does it make
> any assumptions about the existence of a frame pointer on the stack?
> Enabling stack unwinding automatically disables the framepointer.

If it uses CALLER_ADDRESSx() then it won't work with unwinding enabled.
See 5613/1 (which is pending in the devel branch.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

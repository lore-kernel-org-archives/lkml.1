Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbYCULba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbYCULba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 07:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbYCULbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 07:31:22 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49910 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbYCULbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 07:31:21 -0400
Date: Fri, 21 Mar 2008 17:01:34 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yakov Lerner <iler.ml@gmail.com>, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] Subject: kprobes-x86: correct post-eip value in
	post_hander()
Message-ID: <20080321113134.GA7620@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <E1Jao7N-0005OC-Fe@io.site5.com> <20080321110804.GY20420@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321110804.GY20420@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 12:08:04PM +0100, Ingo Molnar wrote:
> 
> * Yakov Lerner <iler.ml@gmail.com> wrote:
> 
> > I was trying to get the address of instruction to be executed next 
> > after the kprobed instruction.  But regs->eip in post_handler() 
> > contains value which is useless to the user. It's pre-corrected value. 
> > This value is difficult to use without access to resume_execution(), 
> > which is not exported anyway. I moved the invocation of post_handler() 
> > to *after* resume_execution(). Now regs->eip contains meaningful value 
> > in post_handler().
> > 
> > I do not think this change breaks any backward-compatibility. To make 
> > meaning of the old value, post_handler() would need access to 
> > resume_execution() which is not exported.  I have difficulty to 
> > believe that previous, uncorrected, regs->eip can be meaningfully used 
> > in post_handler().
> 
> thanks, i've added your patch to the .26 bucket of x86.git, but it would 
> be nice to get an Ack/Nack from a kprobes person as well.
 
Ingo,

I've tested Yakov's more comprehensive patch on powerpc too. This has my
ack.

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

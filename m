Return-Path: <linux-kernel-owner+w=401wt.eu-S1030246AbXBQShw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030246AbXBQShw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 13:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030252AbXBQShw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 13:37:52 -0500
Received: from www.osadl.org ([213.239.205.134]:53035 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030246AbXBQShv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 13:37:51 -0500
Subject: Re: 2.6.20-git: undefined reference to `smp_call_function_single'
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1171736745.3379.24.camel@mulgrave.il.steeleye.com>
References: <200702162108.01206.lenb@kernel.org>
	 <1171707924.30834.111.camel@localhost.localdomain>
	 <1171736745.3379.24.camel@mulgrave.il.steeleye.com>
Content-Type: text/plain
Date: Sat, 17 Feb 2007 19:42:38 +0100
Message-Id: <1171737758.30834.154.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-17 at 12:25 -0600, James Bottomley wrote:
> > Yup, this obscure machine is missing smp_call_function_single().
> > 
> > James ?
> 
> Where's this coming from?  smp_call_function_single() is an obscure kvm
> only API think for x86/ia64 ... it's not supported on any other
> architecure.  The symbol you have is blowing up in the kernel
> subdirectory which suggests someone has tried to use it in generic code,
> which will fail to compile on a lot more than voyager and parisc ...

smp_call_function_single() was added with commit:
eaa70773e750cc09d60938bceacd028bc76b8e3a

   [PATCH] i386: add smp_call_function_single
    
    Continiung the series of small patches necessary for the perfmon subsystem,
    here is a patch that adds support for the smp_call_function_single()
    function for i386.  It exists for almost all other architectures but i386.
    The perfmon subsystem needs it in one case to free some state on a
    designated remote CPU.

It's not an obscure kvm API :) But the claim that it is available on
almost all other architectures but i386 is wrong. Only x86_64, ia64 and
i386 have it.

The function is defined in include/linux/smp.h and there is no
indication that it is an architecture specific thingy. What a steaming
pile of ....

/me grumbles

	tglx



Return-Path: <linux-kernel-owner+w=401wt.eu-S2993050AbXBQS1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993050AbXBQS1H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 13:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993051AbXBQS1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 13:27:07 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:50677 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993050AbXBQS1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 13:27:06 -0500
Subject: Re: 2.6.20-git: undefined reference to `smp_call_function_single'
From: James Bottomley <James.Bottomley@SteelEye.com>
To: tglx@linutronix.de
Cc: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1171707924.30834.111.camel@localhost.localdomain>
References: <200702162108.01206.lenb@kernel.org>
	 <1171707924.30834.111.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 17 Feb 2007 12:25:45 -0600
Message-Id: <1171736745.3379.24.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-17 at 11:25 +0100, Thomas Gleixner wrote:
> On Fri, 2007-02-16 at 21:08 -0500, Len Brown wrote:
> > Yes, an obscure .config, but it used to build before today:
> >
> > kernel/built-in.o: In function `tick_broadcast_on_off':
> > (.text+0x1b6f0): undefined reference to `smp_call_function_single'
> 
> Yup, this obscure machine is missing smp_call_function_single().
> 
> James ?

Where's this coming from?  smp_call_function_single() is an obscure kvm
only API think for x86/ia64 ... it's not supported on any other
architecure.  The symbol you have is blowing up in the kernel
subdirectory which suggests someone has tried to use it in generic code,
which will fail to compile on a lot more than voyager and parisc ...

James



Return-Path: <linux-kernel-owner+w=401wt.eu-S1751411AbXCDE1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411AbXCDE1q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 23:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbXCDE1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 23:27:46 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:51895 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbXCDE1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 23:27:46 -0500
Date: Sun, 4 Mar 2007 03:03:39 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: "remi.chateauneu@gmail.com" <remi.chateauneu@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: asm/atomic.h and user code
Message-ID: <20070304030339.GA5921@linux-mips.org>
References: <1172958807.453840.180700@30g2000cwc.googlegroups.com> <45EA2A6B.9090404@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EA2A6B.9090404@shaw.ca>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2007 at 08:09:47PM -0600, Robert Hancock wrote:
> Date:	Sat, 03 Mar 2007 20:09:47 -0600
> From:	Robert Hancock <hancockr@shaw.ca>
> Subject: Re: asm/atomic.h and user code
> To:	"remi.chateauneu@gmail.com" <remi.chateauneu@gmail.com>,
> 	linux-kernel <linux-kernel@vger.kernel.org>
> Content-type: text/plain; charset=ISO-8859-1; format=flowed
> 
> remi.chateauneu@gmail.com wrote:
> >Is it me or it seems it is not possible anymore to use asm/atomic.h in
> >non-kernel code ? Thanks.
> 
> The atomic functions, as with any internal kernel data structures, were 
> never intended to be used in userspace. In particular, the atomic 
> functions depend on config settings like CONFIG_SMP in order to actually 
> be atomic, and that's not guaranteed in userspace.

Some of the atomic headers use constructs such as disabling interrupts
which are not permitted in user space and if they were, would _silently_
fail.  Other atomic operations such as <asm/bitops.h>, <asm/spinlock.h>
and xchg() <asm/system.h> have the same restriction.

Another trap is that in userspace PIC code may be used while in the kernel
it generally is not used and therefore much of the inline assembler code in
the kernel might fail.

In short, the kernel is a different universe :-)

  Ralf

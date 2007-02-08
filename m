Return-Path: <linux-kernel-owner+w=401wt.eu-S1423317AbXBHVDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423317AbXBHVDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 16:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423345AbXBHVDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 16:03:14 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38953 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423322AbXBHVDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 16:03:09 -0500
Date: Thu, 8 Feb 2007 13:03:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: wcohen@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Size of 2.6.20 task_struct on x86_64 machines
Message-Id: <20070208130300.e819bd7f.akpm@linux-foundation.org>
In-Reply-To: <20070208.121945.102574093.davem@davemloft.net>
References: <45CB4C55.4070902@redhat.com>
	<20070208.121945.102574093.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Feb 2007 12:19:45 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: William Cohen <wcohen@redhat.com>
> Date: Thu, 08 Feb 2007 11:14:13 -0500
> 
> > This past week I was playing around with that pahole tool
> > (http://oops.ghostprotocols.net:81/acme/dwarves/) and looking at the
> > size of various struct in the kernel. I was surprised by the size of
> > the task_struct on x86_64, approaching 4K.  I looked through the
> > fields in task_struct and found that a number of them were declared as
> > "unsigned long" rather than "unsigned int" despite them appearing okay
> > as 32-bit sized fields. On x86_64 "unsigned long" ends up being 8
> > bytes in size and forces 8 byte alignment. Is there a reason there
> > a reason they are "unsigned long"?
> 
> I think at one point we used the atomic bit operations to operate on
> things like tsk->flags, and those interfaces require unsigned long as
> the type.
> 
> That doesn't appear to be the case any longer, so at a minimum
> your tsk->flags conversion to unsigned int should be ok.

Yeah, afacit everything in there is OK and happily all the
converted-to-32-bit quantities happen to be contiguous with other 32-bit
quantities.

Most architectures' bitops functions take unsigned long * so if anyone is
using bitops on these things we should get to hear about it.


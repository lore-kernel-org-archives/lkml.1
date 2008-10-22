Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbYJVT23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbYJVT23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYJVT2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:28:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535AbYJVT2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:28:19 -0400
Date: Wed, 22 Oct 2008 12:26:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       sagar.abhishek@gmail.com, davem@davemloft.net, tglx@linutronix.de,
       peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: Re: [PATCH 04/11] ftrace: comment arch ftrace code
Message-Id: <20081022122654.744d9e85.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0810221513490.25759@gandalf.stny.rr.com>
References: <20081022184313.179487464@goodmis.org>
	<20081022185136.134729572@goodmis.org>
	<20081022120951.11665534.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0810221513490.25759@gandalf.stny.rr.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 15:16:33 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> > Also, I hope that the above code is called from within a
> > pagefault_disable()d region?  Or are relying upon some magical
> > side-effect of something which happens to do the same thing as
> > pagefault_disable()?  IOW: by what means does the above code ensure
> > that do_page_fault() will see in_atomic()==true?
> 
> This code is called from kstop_machine, or simply has interrupts disabled.

in_atomic() doesn't test irqs_disabled()!

Still, probe_kernel_write() correctly handles the
secret-argument-passing to do_page_fault().


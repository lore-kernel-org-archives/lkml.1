Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYICLDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYICLDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 07:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYICLDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 07:03:09 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:62604 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbYICLDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 07:03:08 -0400
Date: Wed, 3 Sep 2008 13:02:24 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: "Voss, Nikolaus" <N.Voss@weinmann.de>
Cc: <kernel@avr32linux.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add kernel support for oprofile callgraphs on AVR32
Message-ID: <20080903130224.251cd97c@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <4A01BA1129E3AD489AA4409A99D9076775A42C@wm020.weinmann.com>
References: <20080903112930.56ebac51@hskinnemo-gx745.norway.atmel.com>
	<4A01BA1129E3AD489AA4409A99D9076775A42C@wm020.weinmann.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Sep 2008 11:02:20.0357 (UTC) FILETIME=[892E7F50:01C90DB4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Voss, Nikolaus" <N.Voss@weinmann.de> wrote:
> Hi,
> 
> > Hmm. This appears to be the third backtracer added to avr32, the first
> > two being dump_stack() and friends in arch/avr32/kernel/process.c, and
> > save_stack_trace() in arch/avr32/kernel/stacktrace.c.
> > 
> > Would be nice if some of this could be consolidated.
> 
> I considered using one of them, in fact I also have a version with an
> extended stacktrace.c. But due to the small size of the kernel stacktracer
> (only a few lines), I found it cleaner to create a separate version. The
> overall size is smaller and it cannot potentially mess up other things.
> Cf. e.g. the x86 tracer which is of the generic type, but comparatively big
> and hard to follow through the places.

Good point.

> > > +		/* Assume we have frame pointers in user mode process */
> > 
> > What happens if we don't? I assume it will stop when it detects that
> > the frame pointer isn't monotonically increasing or when it gets a
> > fault?
> 
> Right. This might lead to false information in oprofile, this case is
> described in the oprofile docs. 

Ok.

I've applied it to the avr32 tree along with a couple of trivial
checkpatch fixes. There's one remaining warning:

WARNING: externs should be avoided in .c files
#125: FILE: arch/avr32/oprofile/op_model_avr32.c:25:
+void avr32_backtrace(struct pt_regs * const regs, unsigned int depth);

total: 0 errors, 1 warnings, 102 lines checked

We should probably add a header file somewhere, but I'm too lazy to do
it right now.

Haavard

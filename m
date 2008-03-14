Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbYCNQdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbYCNQdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 12:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYCNQdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 12:33:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54474 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYCNQdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 12:33:16 -0400
Date: Fri, 14 Mar 2008 09:31:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Yan <rottled@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22.6 - Discrepancy between running and on-disk kernels
Message-ID: <20080314093138.22861a55@laptopd505.fenrus.org>
In-Reply-To: <54b90fdf0803140908k44bee3a2gbf4187ae40dad4b3@mail.gmail.com>
References: <54b90fdf0803140751m71935a09r9b039ca6eb124f4d@mail.gmail.com>
	<20080314090049.346d7428@laptopd505.fenrus.org>
	<54b90fdf0803140908k44bee3a2gbf4187ae40dad4b3@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008 12:08:16 -0400
Yan <rottled@gmail.com> wrote:

> Can you point me to where in the source that self-patching happens? I
> tried grep'ing
> through the source for anything relevant, and came out empty handed.


in the apply_alternatives() function

> 
> -yan
> 
> On Fri, Mar 14, 2008 at 12:00 PM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> > On Fri, 14 Mar 2008 10:51:43 -0400
> >  Yan <rottled@gmail.com> wrote:
> >
> >  > Hello,
> >  >
> >  > I have been trying to compare the code from the on-disk
> >  > compressed kernel that was booted and the running kernel
> >  > extracted from /dev/kmem. I extracted the kernel's code from the
> >  > disk image by stripping the head.S and similar and gunzipping
> >  > it, and extracted the kernel from /dev/kmem by reading data
> >  > between _text and _etext symbol offsets.
> >  >
> >  > I then ran both through a disassembler and diff'ed the outputs.
> >  > Predictably, the disassembly was similar, but not identical. Some
> >  > instructions (e.g. bts) had a 'lock' prefix, where as others had
> >  > a 'nop' in its place.
> >  >
> >  > There were other differences with some instructions like mfence.
> >  > Everything else matched just fine, the differences were mostly in
> >  > memory-referencing instructions.
> >  >
> >  > My question is, what can be changing the kernel between being on
> >  > static storage and being loaded?
> >
> >  the kernel code is self-patching, it gets modified to match your
> > system during boot time. So you cannot assume that the kernel on
> > disk and the kernel in memory are identical.
> >  (Same goes for modules)
> >


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

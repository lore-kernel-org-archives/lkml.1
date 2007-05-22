Return-Path: <linux-kernel-owner+w=401wt.eu-S934723AbXEVQSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934723AbXEVQSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757674AbXEVQSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:18:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48979 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757473AbXEVQSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:18:43 -0400
Date: Tue, 22 May 2007 09:15:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: eranian@hpl.hp.com
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org, ak@suse.de,
       tony.luck@intel.com
Subject: Re: is TIF_NOTIFY_RESUME used?
Message-Id: <20070522091517.251cc2d0.akpm@linux-foundation.org>
In-Reply-To: <20070522160737.GI27631@frankl.hpl.hp.com>
References: <20070522124713.GB27428@frankl.hpl.hp.com>
	<20070522090210.1388ff3e.akpm@linux-foundation.org>
	<20070522160737.GI27631@frankl.hpl.hp.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 09:07:37 -0700
Stephane Eranian <eranian@hpl.hp.com> wrote:

> Andrew,
> 
> On Tue, May 22, 2007 at 09:02:10AM -0700, Andrew Morton wrote:
> > On Tue, 22 May 2007 05:47:13 -0700
> > Stephane Eranian <eranian@hpl.hp.com> wrote:
> > 
> > > Hello,
> > > 
> > > For perfmon, we need a couple of TIF bits. It seems that with 2.6.22-rc2
> > > there is now a TIF_RESTORE_SIGMASK which uses the last remaining bit in the
> > > first 7 bits of the thread flag. Many architectures, including IA-64, rely
> > > on the fact that some of the TIF flags (TIF_ALL_WORKMASK or TIF_ALL_WORK)
> > > tested on kernel exit reside in the low 8-bit or 7-bit because they use
> > > instructions (such as add r1=imm8,r2 on IA-64) which operate on 8 or 7 bit
> > > immediate.
> > > 
> > > On IA-64, adding that one perfmon flag (as bit 7) would cause some
> > > restructuring in the kernel exit path but also in all the lightweight syscall
> > > handlers.
> > > 
> > > I looked at all the low order TIF flags and found that TIF_NOTIFY_RESUME 
> > > was never set nor used anywhere in any architecture. Is that really the case?
> > > 
> > > If so, we could get rid of it and free up one low-order TIF bit.
> > > 
> > 
> > My grepping argees with yours.  The only place where TIF_NOTIFY_RESUME gets
> > altered is in ./arch/ia64/kernel/perfmon.c.
> 
> Yes, and that is with the old IA-64 code. In the new one I used a dedicated
> TIF flag.
> 
> Shall we just get rid of the flag, then?
> 

I'd say so, yes.

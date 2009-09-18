Return-Path: <linux-kernel-owner+w=401wt.eu-S1752244AbZIRToT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbZIRToT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbZIRToP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:44:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52363 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbZIRToO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:44:14 -0400
Date: Fri, 18 Sep 2009 20:44:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= RISS <frederic.riss@gmail.com>
Cc: Nicolas Pitre <nico@fluxnic.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: Make kprobes unregistration SMP safe
Message-ID: <20090918194403.GC6601@n2100.arm.linux.org.uk>
References: <1253078476.5021.65.camel@funkybook> <alpine.LFD.2.00.0909172039070.24133@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0909172039070.24133@xanadu.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 08:40:10PM -0400, Nicolas Pitre wrote:
> On Wed, 16 Sep 2009, Frédéric RISS wrote:
> 
> > ARM kprobes use an illegal instruction to trigger kprobes. In the
> > current implementation, there's a race between the unregistration of a
> > kprobe and the illegal instruction exception handler if they run at the
> > same time on different cores. 
> > 
> > When reading the value of the undefined instruction, the exception
> > handler might get the original legal instruction as just patched
> > concurrently by arch_disarm_kprobe(). When this happen the kprobe
> > handler won't run, and thus the exception handler will oops because it
> > believe it just hit an undefined instruction in kernel space.
> > 
> > The following patch synchronizes the code patching in the kprobes
> > unregistration using stop_machine and thus avoids the above race.
> > 
> > Signed-off-by: Frederic RISS <frederic.riss@gmail.com>
> 
> Acked-by: Nicolas Pitre <nico@fluxnic.net>

Frédéric, please submit to the patch system, thanks.

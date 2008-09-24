Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbYIXMhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbYIXMhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 08:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbYIXMhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 08:37:35 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37494 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYIXMhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 08:37:34 -0400
Date: Wed, 24 Sep 2008 14:35:52 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: benh@kernel.crashing.org
Cc: Milton Miller <miltonm@bga.com>, Jan-Bernd Themann <ossthema@de.ibm.com>,
       Christoph Raisch <RAISCH@de.ibm.com>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH HACK] powerpc: quick hack to get a functional eHEA with
 hardirq preemption
Message-ID: <20080924143552.29a14f10@bull.net>
In-Reply-To: <1222251467.8277.73.camel@pasglop>
References: <200809231743.23828.ossthema@de.ibm.com>
	<20080915100406.342e027a@bull.net>
	<200809240958.m8O9wM7k010996@sullivan.realtime.net>
	<1222251467.8277.73.camel@pasglop>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Ben,

On Wed, 24 Sep 2008 20:17:47 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Wed, 2008-09-24 at 04:58 -0500, Milton Miller wrote:
> > The per-interrupt mask and unmask calls have to go through RTAS, a
> > single-threaded global context, which in addition to increasing
> > path length will really limit scalability.  The interrupt controller
> > poll and reject facilities are accessed through hypervisor calls
> > which are comparable to a fast syscall, and parallel to all cpus.
> 
> Note also that the XICS code thus assumes, iirc, as does the cell IIC
> code, that eoi is called on the -same- cpu that fetched the interrupt
> initially. That assumption can be broken with IRQ threads no ?

  No, the fetch and the eoi are both done in interrupt context before
the hardirq thread is woken up.

  On the other hand, the mask+eoi and the unmask may well happen
on different cpus as there's only one hardirq thread per irq on
the system. Don't know if this is a problem with the XICS though.

  Thanks,

  Sebastien.

> 
> Ben.
> 
> 
> 

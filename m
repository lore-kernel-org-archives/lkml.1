Return-Path: <linux-kernel-owner+w=401wt.eu-S965838AbXBOKqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965838AbXBOKqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 05:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965841AbXBOKqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 05:46:00 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3536 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965838AbXBOKp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 05:45:59 -0500
Date: Thu, 15 Feb 2007 10:45:47 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Paul Mundt <lethal@linux-sh.org>, Maximus <john.maximus@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: irqdesc porting help
Message-ID: <20070215104547.GA15772@flint.arm.linux.org.uk>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Maximus <john.maximus@gmail.com>, linux-kernel@vger.kernel.org
References: <3634de740702142231k938a4c5ic824c2eefc95c1b0@mail.gmail.com> <20070215103347.GA18690@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215103347.GA18690@linux-sh.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 07:33:47PM +0900, Paul Mundt wrote:
> On Thu, Feb 15, 2007 at 12:01:37PM +0530, Maximus wrote:
> > Im trying to port some drivers between 2.6.14 and 2.6.19
> > 
> > I find that irqdesc has changed completely. how do i port
> > the drivers between 2.6.14 and 2.6.19?
> > 
> > is there a porting guide available to port the drivers
> > which use irqdesc?.
> > 
> > my drivers use variables triggered, ... which dont exist in 2.6.19
> > irqdesc strcuture.
> > 
> Presumably you're talking about the struct hw_interrupt_type and the lack
> of an irq_desc[irq].handler? There's some migration helper glue in
> include/linux/irq.h that you can use, but you're better off converting
> completely. You can at least get it building again by changing to
> irq_desc[irq].chip, but you really want a proper irq_chip implementation
> to go along with this, rather than munging in the hw_interrupt_type.

It should be asked - why are drivers poking about in the irqdesc
structure?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

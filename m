Return-Path: <linux-kernel-owner+w=401wt.eu-S965813AbXBOKgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965813AbXBOKgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 05:36:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965815AbXBOKgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 05:36:06 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:41888 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965813AbXBOKgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 05:36:04 -0500
Date: Thu, 15 Feb 2007 19:33:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Maximus <john.maximus@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: irqdesc porting help
Message-ID: <20070215103347.GA18690@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Maximus <john.maximus@gmail.com>, linux-kernel@vger.kernel.org
References: <3634de740702142231k938a4c5ic824c2eefc95c1b0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3634de740702142231k938a4c5ic824c2eefc95c1b0@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 12:01:37PM +0530, Maximus wrote:
> Im trying to port some drivers between 2.6.14 and 2.6.19
> 
> I find that irqdesc has changed completely. how do i port
> the drivers between 2.6.14 and 2.6.19?
> 
> is there a porting guide available to port the drivers
> which use irqdesc?.
> 
> my drivers use variables triggered, ... which dont exist in 2.6.19
> irqdesc strcuture.
> 
Presumably you're talking about the struct hw_interrupt_type and the lack
of an irq_desc[irq].handler? There's some migration helper glue in
include/linux/irq.h that you can use, but you're better off converting
completely. You can at least get it building again by changing to
irq_desc[irq].chip, but you really want a proper irq_chip implementation
to go along with this, rather than munging in the hw_interrupt_type.

You can easily compare before-and-after versions of most of the IRQ
controllers to identify the minimal changes required.

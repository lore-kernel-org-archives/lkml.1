Return-Path: <linux-kernel-owner+w=401wt.eu-S932705AbXBONLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705AbXBONLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 08:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932706AbXBONLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 08:11:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:57002 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705AbXBONL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 08:11:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s//w/APf0/1gGcHyIN+6depK4J4Q4HNCZJl93+EJB4/uFcsmlVX7l/5TfHfpRO+ce8r0Lc2XMiSmLU1Nv7Fr7hhTnRafQjId8cleSC5fzia6/+zG6vq3Mk1i4NIs5SF8RYSsooTJnLhgmI7hzoscJ9lrZJgj9vEy8IB3N7M76es=
Message-ID: <3634de740702150511y52985c2ak21eb663961193f20@mail.gmail.com>
Date: Thu, 15 Feb 2007 18:41:25 +0530
From: Maximus <john.maximus@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Subject: Re: irqdesc porting help
In-Reply-To: <20070215104547.GA15772@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3634de740702142231k938a4c5ic824c2eefc95c1b0@mail.gmail.com>
	 <20070215103347.GA18690@linux-sh.org>
	 <20070215104547.GA15772@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   My drivers in 2.6.14 use statements like
             desc->triggered = 1;
   And desc also points to some members of irqdesc which arent in
2.6.19 but in 2.6.14.

   Im a newbie, What changes am i supposed to make to make it work in 2.6.19.
   Im not sure what changes are exactly needed.


  Please Advice,

  Regards,
   Jo



On 2/15/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> On Thu, Feb 15, 2007 at 07:33:47PM +0900, Paul Mundt wrote:
> > On Thu, Feb 15, 2007 at 12:01:37PM +0530, Maximus wrote:
> > > Im trying to port some drivers between 2.6.14 and 2.6.19
> > >
> > > I find that irqdesc has changed completely. how do i port
> > > the drivers between 2.6.14 and 2.6.19?
> > >
> > > is there a porting guide available to port the drivers
> > > which use irqdesc?.
> > >
> > > my drivers use variables triggered, ... which dont exist in 2.6.19
> > > irqdesc strcuture.
> > >
> > Presumably you're talking about the struct hw_interrupt_type and the lack
> > of an irq_desc[irq].handler? There's some migration helper glue in
> > include/linux/irq.h that you can use, but you're better off converting
> > completely. You can at least get it building again by changing to
> > irq_desc[irq].chip, but you really want a proper irq_chip implementation
> > to go along with this, rather than munging in the hw_interrupt_type.
>
> It should be asked - why are drivers poking about in the irqdesc
> structure?
>
> --
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:
>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbXJLPu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbXJLPu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 11:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbXJLPuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 11:50:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:57233 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbXJLPuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 11:50:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QsZUtKfy9g71BargZNCzZvy4/V24RMIYMwiMoHdpdCLKVFYV0wIeg0gA+o3s2Pqo4q7f97pu0qrTQ4I/dAJ23BrsFU+RbP5tzeWoWikpVaeeAY6q+Pwc1L3SYu1DUFvCpu5H/rHnB1uFQTsWl2I+seZyXq7Ym+uAwvshPrt7/BE=
Message-ID: <d120d5000710120850p64aae40ep95f98cfcee7d8d6f@mail.gmail.com>
Date: Fri, 12 Oct 2007 11:50:12 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: bryan.wu@analog.com
Subject: Re: [PATCH try #2] Input/Joystick Driver: add support AD7142 joystick driver
Cc: linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <1192203593.7089.4.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192174727.6247.20.camel@roc-laptop>
	 <d120d5000710120749o2505dd7aq42559c35298f05d0@mail.gmail.com>
	 <1192203593.7089.4.camel@roc-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/07, Bryan Wu <bryan.wu@analog.com> wrote:
> On Fri, 2007-10-12 at 10:49 -0400, Dmitry Torokhov wrote:
> > Hi Bryan,
> >
> > On 10/12/07, Bryan Wu <bryan.wu@analog.com> wrote:
> > > +
> [snip]
> > > +
> > > +static void ad7142_close(struct input_dev *dev)
> > > +{
> > > +       free_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX, ad7142_interrupt);
> > > +       kthread_stop(ad7142_task);
> >
> > Don't you need to write something over i2c to shut the devoce off?
> > What stops it from continuing to generate interrupts?
> >
> Actually, I am going to use "completion" to replace the whole
> wait_interrupt_xxx and intr_flag things which original from Aubrey. How
> do you think of that?
>

I don't think it is a very good idea - for me completion is one-time
deal. You use it and then you are done. How about firing a work from
interrupt and either rely on the default workqueue (keventd) or create
your own to execute it?

Thank you.

-- 
Dmitry

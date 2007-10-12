Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbXJLTVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbXJLTVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 15:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbXJLTVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 15:21:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:19933 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758328AbXJLTVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 15:21:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=Sqn1xAc3vuGh2HbNCJFWpaHjr165PnPUTgvLUSfOU2x7zn1ASov4HLji6vMzmDyw0QzZzhYKT1VP6rq79ZTLgXk6Lu3N4hitdg2XXecRoodI7rUjfCPGMdBSeHnFI35x9d2U5/ZizC66HF8Pl9fulUg01NAW1JTAaPRtwMP6hX0=
Date: Fri, 12 Oct 2007 21:21:11 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Bryan Wu <bryan.wu@analog.com>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH try #2] Input/Joystick Driver: add support AD7142 joystick driver
Message-ID: <20071012192111.GB12559@Ahmed>
References: <1192174727.6247.20.camel@roc-laptop> <20071012164131.GA12559@Ahmed> <d120d5000710121029q400d05d8s38ae8769f2f44b15@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000710121029q400d05d8s38ae8769f2f44b15@mail.gmail.com>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 01:29:31PM -0400, Dmitry Torokhov wrote:
> Hi Ahmed,
> 

Hi :),

> On 10/12/07, Ahmed S. Darwish <darwish.07@gmail.com> wrote:
> > On Fri, Oct 12, 2007 at 03:38:47PM +0800, Bryan Wu wrote:
> > >
> > > Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> > > ---
> >
> > Hi Bryan,
> >
> > Why creating module's own kthread to call ad7142_decode and process keycodes
> > instead of using a tasklet ?
> >
> 
> Yo can't access i2c from a tasklet context.
> 
> > Isn't disabling device interrupts from the begining of the ISR "ad7142_interrupt"
> > till the kthread "ad7142_thread" got waked-up and scheduled a long time,
> > espicially if there's a high load on the userspace side ?
> >
> 
> It is OK - you disable a specific interrupt line preventing it from
> raising any more IRQs until current one is serviced. 

Won't this affect system responsiveness if the IRQ line was shared ?

>
> This is different from disabling interrupts on CPU.
> 

mm, Why disabling interrupts in general. Doesn't IRQ hanlers of the same kind got
executed in a serialized fashion even on SMPs ?. If so, why not just wakeup our
custom-thread or use workqueues and let them do their business ?

It's the first time for me to read others' patches carefully and kindly ask about
some explanations. I hope I'm not bothering people with my misunderstandings!
(till I get more experienced).


Thanks,

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

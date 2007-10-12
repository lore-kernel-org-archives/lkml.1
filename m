Return-Path: <linux-kernel-owner+w=401wt.eu-S1762606AbXJLR3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762606AbXJLR3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757786AbXJLR3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:29:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:12631 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbXJLR3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:29:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dKGtBT9ndGjp+4WWPR6mQORD3ljyyHy9iVKZ87I07wwPaIslKZ4fOe1Q+dN5hhRBcicohqWNlEtVRxu+gOpGqpC0o3m6EZXI/CnDXZ2Mi22oEH/QA/yBq7KnEp7vnfWzs16VuwFvii8J/GQyv3UG2ZnvZBDoYN8iexc0ZmdUIqU=
Message-ID: <d120d5000710121029q400d05d8s38ae8769f2f44b15@mail.gmail.com>
Date: Fri, 12 Oct 2007 13:29:31 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [PATCH try #2] Input/Joystick Driver: add support AD7142 joystick driver
Cc: "Bryan Wu" <bryan.wu@analog.com>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20071012164131.GA12559@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192174727.6247.20.camel@roc-laptop>
	 <20071012164131.GA12559@Ahmed>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ahmed,

On 10/12/07, Ahmed S. Darwish <darwish.07@gmail.com> wrote:
> On Fri, Oct 12, 2007 at 03:38:47PM +0800, Bryan Wu wrote:
> >
> > Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> > ---
>
> Hi Bryan,
>
> Why creating module's own kthread to call ad7142_decode and process keycodes
> instead of using a tasklet ?
>

Yo can't access i2c from a tasklet context.

> Isn't disabling device interrupts from the begining of the ISR "ad7142_interrupt"
> till the kthread "ad7142_thread" got waked-up and scheduled a long time,
> espicially if there's a high load on the userspace side ?
>

It is OK - you disable a specific interrupt line preventing it from
raising any more IRQs until current one is serviced. This is different
from disabling interrupts on CPU.

> Minor issues below.
>
> > +
> > +/* R    ADC stage 0 - 11 result (uncompensated) actually located in SRAM */
> > +#define ADCRESULT_S0         0x0B
> > +#define ADCRESULT_S1         0x0C
> > +#define ADCRESULT_S2         0x0D
> > +#define ADCRESULT_S3         0x0E
> > +#define ADCRESULT_S4         0x0F
> > +#define ADCRESULT_S5         0x10
> > +#define ADCRESULT_S6         0x11
> > +#define ADCRESULT_S7         0x12
> > +#define ADCRESULT_S8         0x13
> > +#define ADCRESULT_S9         0x14
> > +#define ADCRESULT_S10                0x15
> > +#define ADCRESULT_S11                0x16
> > +
>
> Keeping last two lines aligned with their above counterparts ?

I believe they are aligned if you aplly the patch.

-- 
Dmitry

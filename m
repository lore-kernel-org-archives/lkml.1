Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbXJLUX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbXJLUX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 16:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbXJLUXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 16:23:18 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:35781 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbXJLUXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 16:23:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RrMB9L52IYf+fQItYIbDRrn83OmqT7ZZkEHO79QC3dG/2t7dLwKQxeKzs3l76US4toQ96y6+ri2xnYTKD8JPiKGWSZ+2Tp9IdNUxUMxQCdM0r4ZvB0G5cQxWVgo9dXbaNSRQ6j6I1h8e+9QkIbKP1FQUnJqPPGog+4zJ2Xp9Z8E=
Message-ID: <d120d5000710121323w563cf328s315f95eb6a857b75@mail.gmail.com>
Date: Fri, 12 Oct 2007 16:23:15 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [PATCH try #2] Input/Joystick Driver: add support AD7142 joystick driver
Cc: "Bryan Wu" <bryan.wu@analog.com>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20071012192111.GB12559@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192174727.6247.20.camel@roc-laptop>
	 <20071012164131.GA12559@Ahmed>
	 <d120d5000710121029q400d05d8s38ae8769f2f44b15@mail.gmail.com>
	 <20071012192111.GB12559@Ahmed>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/07, Ahmed S. Darwish <darwish.07@gmail.com> wrote:
> On Fri, Oct 12, 2007 at 01:29:31PM -0400, Dmitry Torokhov wrote:
> >
> > > Isn't disabling device interrupts from the begining of the ISR "ad7142_interrupt"
> > > till the kthread "ad7142_thread" got waked-up and scheduled a long time,
> > > espicially if there's a high load on the userspace side ?
> > >
> >
> > It is OK - you disable a specific interrupt line preventing it from
> > raising any more IRQs until current one is serviced.
>
> Won't this affect system responsiveness if the IRQ line was shared ?

You are right, this would not work in case of shared IRQs. Hovewer
this driver is for an embedded arch and the line is not shared.

>
> >
> > This is different from disabling interrupts on CPU.
> >
>
> mm, Why disabling interrupts in general. Doesn't IRQ hanlers of the same kind got
> executed in a serialized fashion even on SMPs ?. If so, why not just wakeup our
> custom-thread or use workqueues and let them do their business ?

Because you don't want CPU to be continually interrupted while untill
right thread gets scheduled. I think using work[queue] is the best
solution for this driver, but you still want to mask that particular
IRQ off until you do the read.

-- 
Dmitry

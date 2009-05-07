Return-Path: <linux-kernel-owner+w=401wt.eu-S1761472AbZEGRLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761472AbZEGRLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 13:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbZEGRLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 13:11:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39169 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753469AbZEGRLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 13:11:10 -0400
Date: Thu, 7 May 2009 18:09:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Christoph Lameter <cl@linux.com>,
       Alok Kataria <akataria@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
Message-ID: <20090507180909.4b0a8672@lxorguk.ukuu.org.uk>
In-Reply-To: <4A031269.3000603@garzik.org>
References: <1241462661.412.8.camel@alok-dev1>
	<4A00ADDE.9000908@zytor.com>
	<1241560625.8665.17.camel@alok-dev1>
	<alpine.DEB.1.10.0905071010170.24528@qirst.com>
	<20090507161440.5b9c067d@lxorguk.ukuu.org.uk>
	<4A02FE91.8070006@zytor.com>
	<4A031269.3000603@garzik.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 May 2009 12:55:05 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> H. Peter Anvin wrote:
> > Alan Cox wrote:
> >> Hooray - finally someone admits the *real* problem here, and for power
> >> management too. Otherwise known as "referencing jiffies as a variable must
> >> die"
> > 
> > Amen.  Also, "using HZ as a unit of measurement must die, too."
> 
> Love to -- now, what will it be replaced with?
> 
> grep for 'deadline' in drivers/ata/libata* to find an example not so 
> easily converted away from jiffies.

I don't see any.

I do see a complicated interface that appears to actually really want to
implement

		add_timer(&foo->expiry_timer);

and checks against the timer completing. In fact it looks as if all the
stuff in there is really down to

		add a timer
		check if it expired
		check how long until it expires
		delete it

And you might as well measure that in HZ=1000's better known as
"milliseconds"


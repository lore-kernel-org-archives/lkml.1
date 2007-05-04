Return-Path: <linux-kernel-owner+w=401wt.eu-S1031355AbXEDVV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031355AbXEDVV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031405AbXEDVV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:21:29 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:18578 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031355AbXEDVV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:21:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NipwwEIz+YrrOrYVc8tPEb0wtUBG9SkxxU4h1Xy1CQP4UQ2nCs+FaMjGmXxpzgCiH2A+WORgcrj42bxdJCUa6KfmDyjz/UjFjgD+DtWcgvwIbNiLZ+UdKNrbkK7VZAXkA/xlo4+WfJvPLGWs1QuOh97GQfb98pNCDCQj/1TPdR8=
Message-ID: <5486cca80705041421y4fcaec01l7acafed1cea4b509@mail.gmail.com>
Date: Fri, 4 May 2007 23:21:26 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Paul Fulghum" <paulkf@microgate.com>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1178308173.3743.14.camel@amdx2.microgate.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <5486cca80705040956g47f634ddp80d67038e8e3305a@mail.gmail.com>
	 <463B7534.6000207@microgate.com>
	 <5486cca80705041013pf481c2an9e639fc9285ba88e@mail.gmail.com>
	 <1178299247.3769.0.camel@amdx2.microgate.com>
	 <5486cca80705041025k46ccf716t8dcd1e6f29e2376e@mail.gmail.com>
	 <1178300493.3619.1.camel@amdx2.microgate.com>
	 <5486cca80705041146x5c5bda70s96ce74e389cc1635@mail.gmail.com>
	 <5486cca80705041206q3a077dedyedb5ac2fbf434ba8@mail.gmail.com>
	 <1178308173.3743.14.camel@amdx2.microgate.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/4/07, Paul Fulghum <paulkf@microgate.com> wrote:
> On Fri, 2007-05-04 at 21:06 +0200, Antonino Ingargiola wrote:
>
> > Filling with echo console-screen.sh I've found that the blocking command is:
> >
> >     unicode_start 2> /dev/null || true
> >
> > or at least the echo before this command is the last shown.
>
> I still don't know what is blocking.
>
> It is possible some tty device is operating with an improperly
> initialized tty structure. I vaguely remember some console code
> creating its own minimally initialized 'dummy' tty structure.
>
> This might be causing the new flush code to hang.
>
> Try this patch which does not call the flush unless a line
> discipline is attached to the tty. That should indicate
> a normally initialized tty structure.
>

Tried. Nothing changes with this patch. I'm booting the patched kernel
commenting out the unicode_start line for now, and there aren't other
"system" problems.

I confirm the behavior previously posted for the serial devices on
flush with this patch too.

"With the patch, flushing the input results effectively in a complete flush.
However after doing the flush I can't read [further] chars [sent to
the serial port]
without closing and reopening the port. I've verified this behavior both
communicating between two serial ports and both communicating with an
usb-serial device (driver cdc-acm)."

Regards,

  ~ Antonio

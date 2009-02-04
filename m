Return-Path: <linux-kernel-owner+w=401wt.eu-S1759630AbZBDVBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630AbZBDVBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbZBDVBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:01:07 -0500
Received: from winston.telenet-ops.be ([195.130.137.75]:56021 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160AbZBDVBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:01:05 -0500
Date: Wed, 4 Feb 2009 22:00:58 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-m68k@vger.kernel.org, uClinux list <uclinux-dev@uclinux.org>
Subject: Re: Fix support for console port other than ttyS0 on mcf.c
In-Reply-To: <20090204202009.GI26064@csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.64.0902042200340.25136@anakin>
References: <20090204201518.GH26064@csclub.uwaterloo.ca>
 <20090204202009.GI26064@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Lennart Sorensen wrote:
> Perhaps CCing linux-m68k@lists.linux-m68k.org would be a good idea.

Thanks, but this is a uClinux driver.

> On Wed, Feb 04, 2009 at 03:15:18PM -0500, Lennart Sorensen wrote:
> > Due to a case of backwards logic, mfc.c always makes the console port be
> > ttyS0 even when you ask for another port.
> > 
> > This patch fixes this issue.
> > 
> > Only when the requested port is NOT in the range 0 to MAXPORTS-1 do we
> > force it to be treated as if port 0 was requested.  Forcing the port to
> > 0 when it is in fact in the range 0 to MAXPORTS is not helpful.
> > 
> > Tested with working console on ttyS2 on a 5271evb.
> > 
> > Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
> > 
> > diff --git a/drivers/serial/mcf.c b/drivers/serial/mcf.c
> > index 56841fe..0eefb07 100644
> > --- a/drivers/serial/mcf.c
> > +++ b/drivers/serial/mcf.c
> > @@ -513,7 +513,7 @@ static int __init mcf_console_setup(struct console *co, char *options)
> >         int parity = 'n';
> >         int flow = 'n';
> > 
> > -       if ((co->index >= 0) && (co->index <= MCF_MAXPORTS))
> > +       if ((co->index < 0) || (co->index >= MCF_MAXPORTS))
> >                 co->index = 0;
> >         port = &mcf_ports[co->index].port;
> >         if (port->membase == 0)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

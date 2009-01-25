Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbZAYO7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbZAYO7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 09:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbZAYO7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 09:59:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51356 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbZAYO7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 09:59:16 -0500
Date: Sun, 25 Jan 2009 15:59:02 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Miklos Vajna <vmiklos@frugalware.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Gabriel C <nix.or.die@googlemail.com>,
       =?iso-8859-15?Q?CS=C9CSY_L=E1szl=F3?= <boobaa@frugalware.org>,
       r.schwebel@pengutronix.de, sven@geggus.net
Subject: Re: System clock runs too fast after 2.6.27 -> 2.6.28.1 upgrade
Message-ID: <20090125145902.GV29067@pengutronix.de>
References: <20090121171423.GI21473@genesis.frugalware.org> <1f1b08da0901211200l88fa89s78a51c4e90878d85@mail.gmail.com> <20090121210726.GK21473@genesis.frugalware.org> <1232573646.6997.21.camel@localhost.localdomain> <20090122195132.GZ21473@genesis.frugalware.org> <20090122235727.GB21473@genesis.frugalware.org> <1232674994.6678.45.camel@localhost.localdomain> <20090123110439.GK15188@elte.hu> <1f1b08da0901231736u46d8981ckc4b89ac66d7d8a5e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1f1b08da0901231736u46d8981ckc4b89ac66d7d8a5e@mail.gmail.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 15:53:27 up 42 days, 19:20,  4 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 05:36:30PM -0800, john stultz wrote:
> On Fri, Jan 23, 2009 at 3:04 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > * john stultz <johnstul@us.ibm.com> wrote:
> >> I'd think this would ideally be more of a subarch in the config
> >> selection like the AMD Elan is, so folks know it really is not just a
> >> extra-support feature and in fact limits what hardware you can use the
> >> resulting kernel on.
> >
> > a better solution is that if RDC is set [it is unset by default] we should
> > turn PIT_TICK_RATE into a variable, defaulting it to 1193182. If a real
> > RDC or ELAN system is running, that variable is changed during early
> > bootup, in the init functions for those platforms.
> 
> Took a quick look at this, and I don't see any detection code for
> either RDC. The X86_ELAN config also has no conditionals, but maybe
> the elan cpufreq code can help here.
> 
> Florian: Is there any way we can check very early (ie: in setup_arch)
> for an RDC box?
> 
> Robert Schwebel, Sven Geggus: Either of you still maintaining the ELAN
> code?  Will the following from elanfreq_cpu_init catch all ELAN chips?
> 
>         if ((c->x86_vendor != X86_VENDOR_AMD) ||
>             (c->x86 != 4) || (c->x86_model != 10))

Nope, I don't have systems available any more with the ELAN.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

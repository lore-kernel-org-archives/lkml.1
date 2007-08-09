Return-Path: <linux-kernel-owner+w=401wt.eu-S940871AbXHIPQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940871AbXHIPQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937428AbXHIPQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:16:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4330 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936386AbXHIPQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:16:24 -0400
Date: Thu, 9 Aug 2007 15:16:10 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Tejun Heo <htejun@gmail.com>
Cc: trenn@suse.de, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Michael Sedkowski <sedmich@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>,
       firmwarekit-discuss <firmwarekit-discuss@bughost.org>
Subject: Re: Disk spin down issue on shut down/suspend to disk
Message-ID: <20070809151610.GD3926@ucw.cz>
References: <1186424492.4355.1.camel@nx6310> <46B76BBC.9010107@gmail.com> <20070806234509.GC27640@khazad-dum.debian.net> <46B816FF.7060303@gmail.com> <20070807125104.GC30661@khazad-dum.debian.net> <46B86F21.4030805@gmail.com> <20070807131651.GE30661@khazad-dum.debian.net> <46B87457.4020704@gmail.com> <1186494328.8780.66.camel@queen.suse.de> <46B87B4A.1020305@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B87B4A.1020305@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > firmwarekit-discuss <firmwarekit-discuss@bughost.org> (added to CC list)
> > see: http://linuxfirmwarekit.org/
> > 
> > But if I understand this problem right, this won't be easy.
> > The ACPI tables are just parsed with system ("iasl ...") and syntactical
> > errors/warnings are printed out.
> > I also thought about a test, interpreting the DSDT and read out values
> > of cpufreq tables and sanity check them. AFAIK the linuxfirmwarekit is
> > not designed for that atm. You need to compile in most parts of the
> > acpica code and parse and interpret DSDT/SSDT code yourself in the
> > firmwarekit core or inside a plugin, then do a walk_namespace call or
> > whatever to find the functions/parts you like to examine. This is a lot
> > work and needs a proper design (providing an interface to plugins to let
> > them easily check specific AML/ASL code).
> 
> Furthermore, we don't really know what we're looking for.  How can you
> tell a given write to an ioport is issuing STANDBYNOW to an ATA disk or
> trying to power the machine off?  Adding to the fun, many modern ATA
> controller have more than one way to issue a command.  Maybe we can
> match accesses inside regions specified by PCI BARs....  :-(

Hmmm... perhaps we should do it the other way. ACPI is allowed to
touch the embedded controller, what else? Maybe we should warn as soon
as API touches non-EC I/O port?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

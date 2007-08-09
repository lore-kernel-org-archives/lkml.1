Return-Path: <linux-kernel-owner+w=401wt.eu-S938611AbXHIP4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938611AbXHIP4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932428AbXHIP4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:56:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55213 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbXHIP4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:56:19 -0400
Subject: Re: Disk spin down issue on shut down/suspend to disk
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Pavel Machek <pavel@ucw.cz>
Cc: Tejun Heo <htejun@gmail.com>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Michael Sedkowski <sedmich@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>,
       firmwarekit-discuss <firmwarekit-discuss@bughost.org>
In-Reply-To: <20070809151610.GD3926@ucw.cz>
References: <1186424492.4355.1.camel@nx6310> <46B76BBC.9010107@gmail.com>
	 <20070806234509.GC27640@khazad-dum.debian.net> <46B816FF.7060303@gmail.com>
	 <20070807125104.GC30661@khazad-dum.debian.net> <46B86F21.4030805@gmail.com>
	 <20070807131651.GE30661@khazad-dum.debian.net> <46B87457.4020704@gmail.com>
	 <1186494328.8780.66.camel@queen.suse.de> <46B87B4A.1020305@gmail.com>
	 <20070809151610.GD3926@ucw.cz>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Thu, 09 Aug 2007 17:56:15 +0200
Message-Id: <1186674976.8780.238.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-09 at 15:16 +0000, Pavel Machek wrote:
> Hi!
> 
> > > firmwarekit-discuss <firmwarekit-discuss@bughost.org> (added to CC list)
> > > see: http://linuxfirmwarekit.org/
> > > 
> > > But if I understand this problem right, this won't be easy.
> > > The ACPI tables are just parsed with system ("iasl ...") and syntactical
> > > errors/warnings are printed out.
> > > I also thought about a test, interpreting the DSDT and read out values
> > > of cpufreq tables and sanity check them. AFAIK the linuxfirmwarekit is
> > > not designed for that atm. You need to compile in most parts of the
> > > acpica code and parse and interpret DSDT/SSDT code yourself in the
> > > firmwarekit core or inside a plugin, then do a walk_namespace call or
> > > whatever to find the functions/parts you like to examine. This is a lot
> > > work and needs a proper design (providing an interface to plugins to let
> > > them easily check specific AML/ASL code).
> > 
> > Furthermore, we don't really know what we're looking for.  How can you
> > tell a given write to an ioport is issuing STANDBYNOW to an ATA disk or
> > trying to power the machine off?  Adding to the fun, many modern ATA
> > controller have more than one way to issue a command.  Maybe we can
> > match accesses inside regions specified by PCI BARs....  :-(
> 
> Hmmm... perhaps we should do it the other way. ACPI is allowed to
> touch the embedded controller, what else? Maybe we should warn as soon
> as API touches non-EC I/O port?

This is not working...
ACPI can and does access all kind of other I/O ports and other
resources.
Hmm, are the disk accesses done by ACPI via OperationRegion/Field
declared variables?
I try to get a check for those clashing with native drivers (hopefully
this approach is successful for 2.6.24, can't say for sure yet), I
wonder whether this one would give a warning like "Libata driver is
using the same SystemIO/SystemMem resources than ACPI OperationRegion
declaration XY".
This would not solve the problem, but at least show the need of such a
test. Such ACPI vs native driver interference problems are very hard
nuts (in identifying and solving).

Can someone post an ASL code snippet how ACPI actually access the disk
and in which parts/functions, pls.

Thanks,

   Thomas


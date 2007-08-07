Return-Path: <linux-kernel-owner+w=401wt.eu-S934500AbXHGNpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934500AbXHGNpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758204AbXHGNpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:45:35 -0400
Received: from ns1.suse.de ([195.135.220.2]:38847 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313AbXHGNpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:45:34 -0400
Subject: Re: Disk spin down issue on shut down/suspend to disk
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Tejun Heo <htejun@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Michael Sedkowski <sedmich@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>,
       firmwarekit-discuss <firmwarekit-discuss@bughost.org>
In-Reply-To: <46B87457.4020704@gmail.com>
References: <1186411815.4355.7.camel@nx6310>
	 <20070806150159.GC31615@khazad-dum.debian.net>
	 <200708061732.03425.rjw@sisk.pl> <46B75459.9020204@gmail.com>
	 <1186424492.4355.1.camel@nx6310> <46B76BBC.9010107@gmail.com>
	 <20070806234509.GC27640@khazad-dum.debian.net> <46B816FF.7060303@gmail.com>
	 <20070807125104.GC30661@khazad-dum.debian.net> <46B86F21.4030805@gmail.com>
	 <20070807131651.GE30661@khazad-dum.debian.net> <46B87457.4020704@gmail.com>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Tue, 07 Aug 2007 15:45:28 +0200
Message-Id: <1186494328.8780.66.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-07 at 22:32 +0900, Tejun Heo wrote:
> Henrique de Moraes Holschuh wrote:
> > On Tue, 07 Aug 2007, Tejun Heo wrote:
> >> Henrique de Moraes Holschuh wrote:
> >>>> approximately translates into "if you have too many boatmen on a ship,
> >>>> it goes to mountain".  We also have a bunch of Toshiba laptops which
> >>> Yeah, that's a problem.  But we can avoid it if we start snooping what ACPI
> >>> is asking us to deliver to the disks, which IMO is an extremely good idea
> >>> anyway.
> >> If it were done that way (by asking OS driver to deliver commands TFs),
> >> I wouldn't have any problem at all.  The spin down command is issued
> >> from deep down in the acpi power off method - entering S5 directly
> >> issues ATA commands bypassing the whole OS except for the ACPI
> >> interpreter.  It's just like the toshiba suspend crap and there's no
> >> standard way to tell whether the acpi power off method is gonna do it or
> >> not.  We'll just have to blacklist it.
> > 
> > Urk. I see.
> > 
> > I'd also suggest adding a FAIL to the Linux firmware toolkit to any DSDT
> > doing this.  Who should we prod to add that check?
> 
> Dunno how the firmware toolkit works but this one can be pretty
> difficult to test (if it were easy, we could test it in libata) as it
> involves entering S5.  If it's possible, I'm all for it.  Also, it would
> be nice if we can test the same thing for S3 and S4.
> 
> Thomas, who should we ask things about the Linux firmware toolkit?  Thanks.

firmwarekit-discuss <firmwarekit-discuss@bughost.org> (added to CC list)
see: http://linuxfirmwarekit.org/

But if I understand this problem right, this won't be easy.
The ACPI tables are just parsed with system ("iasl ...") and syntactical
errors/warnings are printed out.
I also thought about a test, interpreting the DSDT and read out values
of cpufreq tables and sanity check them. AFAIK the linuxfirmwarekit is
not designed for that atm. You need to compile in most parts of the
acpica code and parse and interpret DSDT/SSDT code yourself in the
firmwarekit core or inside a plugin, then do a walk_namespace call or
whatever to find the functions/parts you like to examine. This is a lot
work and needs a proper design (providing an interface to plugins to let
them easily check specific AML/ASL code).

   Thomas



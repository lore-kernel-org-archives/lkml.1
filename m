Return-Path: <linux-kernel-owner+w=401wt.eu-S1764774AbYEFRKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764774AbYEFRKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbYEFRKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:10:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43530 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241AbYEFRKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:10:39 -0400
Date: Tue, 6 May 2008 19:12:48 +0200
From: Holger Macht <hmacht@suse.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Shaohua Li <shaohua.li@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Accardi, Kristen C" <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] bay: Exit if notify handler cannot be installed
Message-ID: <20080506171248.GA20797@homac>
Mail-Followup-To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Shaohua Li <shaohua.li@intel.com>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>
References: <20080505202508.GA3690@homac> <20080506091522.GA4378@homac> <1210065811.12668.1.camel@sli10-desk.sh.intel.com> <20080506093315.GD4378@homac> <20080506093516.GE4378@homac> <20080506152411.GB22828@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506152411.GB22828@khazad-dum.debian.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di 06. Mai - 12:24:11, Henrique de Moraes Holschuh wrote:
> On Tue, 06 May 2008, Holger Macht wrote:
> > On Di 06. Mai - 11:33:16, Holger Macht wrote:
> > > On Di 06. Mai - 17:23:31, Shaohua Li wrote:
> > > > On Tue, 2008-05-06 at 17:15 +0800, Holger Macht wrote:
> > > > > On Mo 05. Mai - 22:25:08, Holger Macht wrote:
> > > > > > If acpi_install_notify_handler() for a bay device fails, the bay
> > > > > driver is
> > > > > > superfluous. Most likely, another driver (like libata) is already
> > > > > caring
> > > > > > about this device anyway. Furthermore,
> > > > > > register_hotplug_dock_device(acpi_handle) from the dock driver must
> > > > > not be
> > > > > > called twice with the same handler. So clean up and exit.
> > > > > 
> > > > > The patch needs some more work. I'll send an updated one as soon as
> > > > > ready.
> > > > The bay driver is duplicated with libata, I thought we should delete it.
> > > > See bug http://bugzilla.kernel.org/show_bug.cgi?id=9526
> > > 
> > > Yes, I know, but couldn't it be helpful on systems not using libata?
> > 
> > Also, libata has to be patched to execute ACPI _EJ0 (not a huge issue, I
> > know) or calling bay's eject_removable drive method.
> 
> It *is* a huge issue.  I think that currently, bay handling on thinkpads
> is broken because of it, and users that expect it to just work could
> well fry their hardware if they're the sort of people who don't LOOK at
> the bay light before they yank stuff from it :-)
> 
> This is not a bug report, but a head's up.  I am at 2.6.23, so I didn't
> test for the bug yet.
> 
> Anyway, when you bind to an ACPI node, you forbid anything else from
> doing it.  This means it is now your problem to handle **ALL**
> capabilities of that node.  This means libata MUST handle ejection, or
> it MUST NOT bind to an ACPI node.

I fully agree. With "not a huge issue", I rather meant that coding this
two lines of code is pretty easy ;-)

Regards,
	Holger

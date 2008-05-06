Return-Path: <linux-kernel-owner+w=401wt.eu-S1763069AbYEFPYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763069AbYEFPYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758099AbYEFPYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:24:15 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33867 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758000AbYEFPYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:24:14 -0400
X-Sasl-enc: GrYqWbNylTNvZkRO7lI6v7tcdUBRIrnVl5dMRRmosOmP 1210087453
Date: Tue, 6 May 2008 12:24:11 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Shaohua Li <shaohua.li@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Accardi, Kristen C" <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] bay: Exit if notify handler cannot be installed
Message-ID: <20080506152411.GB22828@khazad-dum.debian.net>
References: <20080505202508.GA3690@homac> <20080506091522.GA4378@homac> <1210065811.12668.1.camel@sli10-desk.sh.intel.com> <20080506093315.GD4378@homac> <20080506093516.GE4378@homac>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506093516.GE4378@homac>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 May 2008, Holger Macht wrote:
> On Di 06. Mai - 11:33:16, Holger Macht wrote:
> > On Di 06. Mai - 17:23:31, Shaohua Li wrote:
> > > On Tue, 2008-05-06 at 17:15 +0800, Holger Macht wrote:
> > > > On Mo 05. Mai - 22:25:08, Holger Macht wrote:
> > > > > If acpi_install_notify_handler() for a bay device fails, the bay
> > > > driver is
> > > > > superfluous. Most likely, another driver (like libata) is already
> > > > caring
> > > > > about this device anyway. Furthermore,
> > > > > register_hotplug_dock_device(acpi_handle) from the dock driver must
> > > > not be
> > > > > called twice with the same handler. So clean up and exit.
> > > > 
> > > > The patch needs some more work. I'll send an updated one as soon as
> > > > ready.
> > > The bay driver is duplicated with libata, I thought we should delete it.
> > > See bug http://bugzilla.kernel.org/show_bug.cgi?id=9526
> > 
> > Yes, I know, but couldn't it be helpful on systems not using libata?
> 
> Also, libata has to be patched to execute ACPI _EJ0 (not a huge issue, I
> know) or calling bay's eject_removable drive method.

It *is* a huge issue.  I think that currently, bay handling on thinkpads
is broken because of it, and users that expect it to just work could
well fry their hardware if they're the sort of people who don't LOOK at
the bay light before they yank stuff from it :-)

This is not a bug report, but a head's up.  I am at 2.6.23, so I didn't
test for the bug yet.

Anyway, when you bind to an ACPI node, you forbid anything else from
doing it.  This means it is now your problem to handle **ALL**
capabilities of that node.  This means libata MUST handle ejection, or
it MUST NOT bind to an ACPI node.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

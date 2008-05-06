Return-Path: <linux-kernel-owner+w=401wt.eu-S1764248AbYEFRP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764248AbYEFRP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbYEFRPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:15:16 -0400
Received: from ns.suse.de ([195.135.220.2]:45507 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391AbYEFRPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:15:14 -0400
Date: Tue, 6 May 2008 19:17:24 +0200
From: Holger Macht <hmacht@suse.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Shaohua Li <shaohua.li@intel.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Accardi, Kristen C" <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] bay: Exit if notify handler cannot be installed
Message-ID: <20080506171724.GC20797@homac>
Mail-Followup-To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Shaohua Li <shaohua.li@intel.com>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>
References: <20080505202508.GA3690@homac> <20080506091522.GA4378@homac> <1210065811.12668.1.camel@sli10-desk.sh.intel.com> <20080506151846.GA22828@khazad-dum.debian.net> <20080506162049.237af49c@core> <20080506153901.GC22828@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506153901.GC22828@khazad-dum.debian.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di 06. Mai - 12:39:01, Henrique de Moraes Holschuh wrote:
> On Tue, 06 May 2008, Alan Cox wrote:
> > On Tue, 6 May 2008 12:18:46 -0300
> > Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> > > On Tue, 06 May 2008, Shaohua Li wrote:
> > > > The bay driver is duplicated with libata, I thought we should delete it.
> > > > See bug http://bugzilla.kernel.org/show_bug.cgi?id=9526
> > > 
> > > The bay driver is currently useless, BUT it should handle a lot of stuff
> > > libata won't, such as bay batteries, bay floppies, and anything else in
> > > a bay that is not a hard disk.
> > 
> > The bay driver needs to become a service that hands out bay events to
> > all the other drivers for that to happen.
> 
> Seems sensible.  Any pointers?  I wouldn't know how to do it (and
> actually, right now I am busy working on rfkill for some stuff
> thinkpad-acpi needs), but I could try to tack bay after rfkill, if
> nobody beats me to it (hint!)
> 
> BTW: dock handling might share these issues as well.

For pointers, the dock driver should be a good starting point. It already
handles this. For example, libata just calls
register_hotplug_dock_device(handle, callback) and gets notified.

Regards,
	Holger

> 
> The problem has a bit of a hard edge, though: if nobody binds to an ACPI
> node that has an EJ0 subnode, bay needs to do it.  But if someone wants
> to, bay should give the node up, and somehow help that someone handle
> the ejection stuff.

dock does this:

 acpi event --> dock calls all registered handlers from other drivers -->
 --> dock executes _DCK

Regards,
	Holger

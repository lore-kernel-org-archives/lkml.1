Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbZCFKKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbZCFKKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 05:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbZCFKKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 05:10:04 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45260 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbZCFKKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 05:10:03 -0500
Date: Fri, 6 Mar 2009 10:09:51 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Daniel Silverstone <dsilvers@simtec.co.uk>
Cc: Richard Hughes <hughsient@gmail.com>, linux-acpi@vger.kernel.org,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org,
       len.brown@intel.com
Subject: Re: [PATCH] toshiba_acpi: Add full hotkey support
Message-ID: <20090306100951.GA6268@srcf.ucam.org>
References: <20090306003941.GA32403@srcf.ucam.org> <20090306005234.GA32539@srcf.ucam.org> <1236330536.12838.2.camel@hughsie-work.lan> <1236332843.19146.4.camel@petitemort> <20090306095623.GA6014@srcf.ucam.org> <1236333861.19146.9.camel@petitemort>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236333861.19146.9.camel@petitemort>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 10:04:21AM +0000, Daniel Silverstone wrote:
> On Fri, 2009-03-06 at 09:56 +0000, Matthew Garrett wrote:
> > Yes, it'll be as functional as it was previously. They can be remapped 
> > on machines that have a different keymap.
> 
> Since I don't understand the input layer well enough yet, can you
> confirm if it is possible to add new mappings in without changing the
> source? I.E. if laptop <foo> has another hotkey not yet considered, is
> it just an FDI for hal, or is it a source change in the kernel?

Yes, the remapping can be done from userspace.

> > > How will it interact with software stacks like HAL when the lock button
> > > is pressed?
> > I don't really understand the question?
> 
> It was more: will events come out of both the notify method *and*
> the /proc/acpi/toshiba/keys stuff, or will they only come out of the
> notify method if it can be enabled? (I'm just trying to establish that
> things polling /proc/acpi/toshiba/keys won't end up causing duplicated
> events).

Either the kernel or userspace will get the event, but not both. There's 
an argument for disabling the input code if /proc/acpi/toshiba/keys is 
open in order to avoid breaking anything that expects to get the code 
itself.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

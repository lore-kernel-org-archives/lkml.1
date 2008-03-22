Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbYCVVaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbYCVVaf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbYCVVa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:30:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47996 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbYCVVaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:30:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
Date: Sat, 22 Mar 2008 22:29:44 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, "Eric W. Biederman" <ebiederm@xmission.com>,
       nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>,
       Len Brown <len.brown@intel.com>
References: <Pine.LNX.4.44L0.0803221645190.27399-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803221645190.27399-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803222229.45673.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 22 of March 2008, Alan Stern wrote:
> On Sat, 22 Mar 2008, Rafael J. Wysocki wrote:
> 
> > However, as far as the ACPI NVS area is concerned, this is probably not
> > necessary, because the spec wants us to restore the ACPI NVS before calling
> > _WAK, which is just after the image kernel gets the control back.  So, in
> > theory, the ACPI NVS data could be stored in the image and restored by
> > the image kernel from a location known to it (the procedure may be to copy
> > the ACPI NVS data into a region of regular RAM before creating the image and
> > copy them back into the ACPI NVS area in platform->leave(), for example), but
> > I suspect that for this to work we'll have to switch ACPI off in the boot
> > kernel, just prior to passing control back to the image kernel.
> 
> That sounds by far the simplest solution.  If the boot kernel can tell
> (by looking at some header field in the image or any other way) that
> the hibernation used S5 instead of S4, then it should just turn off 
> ACPI before passing control to the image kernel.  Then the image kernel 
> can turn ACPI back on and all should be well.  If you do this, does the 
> NVS region still need to be preserved?

The spec doesn't say much about that, so we'll need to carry out some
experiments.

Still, as far as I can figure out what the spec authors _might_ mean, I think
that it would be inappropriate to restore the ACPI NVS area if S5 was entered
on "power off".  The idea seems to be that the restoration of the ACPI NVS area
should complement whatever has been preserved by the platform over the
hibernation/resume cycle.

IMO, if S5 was entered on "powe off", there are two possible ways to go.
Either ACPI is initialized by the boot kernel, in which case the image kernel
should not touch things like _WAK and similar, just throw away whatever
ACPI-related state it got from the image and try to rebuild the ACPI-related
data from scratch.  Or the boot kernel doesn't touch ACPI and the image kernel
initializes it in the same way as during a fresh boot (that might be difficult,
though).

Thanks,
Rafael

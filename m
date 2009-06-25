Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbZFYOeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbZFYOeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756651AbZFYOeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:34:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52012 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130AbZFYOeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:34:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] Driver Core: Add platform device arch data V3
Date: Thu, 25 Jun 2009 16:34:11 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, paul@pwsan.com, gregkh@suse.de,
       khilman@deeprootsystems.com, stern@rowland.harvard.edu,
       linux-pm@lists.linux-foundation.org
References: <20090610121659.27937.13560.sendpatchset@rx1.opensource.se> <200906242050.57312.rjw@sisk.pl> <aec7e5c30906241925n3eeaee65of0dcf0286f60366d@mail.gmail.com>
In-Reply-To: <aec7e5c30906241925n3eeaee65of0dcf0286f60366d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906251634.12222.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 June 2009, Magnus Damm wrote:
> On Thu, Jun 25, 2009 at 3:50 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> > On Wednesday 24 June 2009, Magnus Damm wrote:
> >> On Fri, Jun 19, 2009 at 1:21 AM, Kevin
> >> Hilman<khilman@deeprootsystems.com> wrote:
> >> > Magnus Damm <magnus.damm@gmail.com> writes:
> >> >
> >> >> From: Magnus Damm <damm@igel.co.jp>
> >> >>
> >> >> Allow architecture specific data in struct platform_device V3.
> >> >>
> >> >> With this patch struct pdev_archdata is added to struct
> >> >> platform_device, similar to struct dev_archdata in found in
> >> >> struct device. Useful for architecture code that needs to
> >> >> keep extra data associated with each platform device.
> >> >>
> >> >> Struct pdev_archdata is different from dev.platform_data, the
> >> >> convention is that dev.platform_data points to driver-specific
> >> >> data. It may or may not be required by the driver. The format
> >> >> of this depends on driver but is the same across architectures.
> >> >>
> >> >> The structure pdev_archdata is a place for architecture specific
> >> >> data. This data is handled by architecture specific code (for
> >> >> example runtime PM), and since it is architecture specific it
> >> >> should _never_ be touched by device driver code. Exactly like
> >> >> struct dev_archdata but for platform devices.
> >> >>
> >> >> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> >> >
> >> > Since there is no 'Feature-desired-by:' tag, I'll addd
> >> >
> >> > Acked-by: Kevin Hilman <khilman@deeprootsystems.com>
> >> >
> >> > For PM on ARM in general, and OMAP in particular we definitely need a
> >> > generic way to handle arch-specific data per platform_device.
> >>
> >> Thanks, Kevin! So ARM in general or at least OMAP wants this, and so
> >> does SuperH.
> >>
> >> Rafael, you kindly gave feedback on earlier versions, are you ok with
> >> this version?
> >
> > Yes, I am.  I'm planning to include it into my linux-next branch for 2.6.32, if
> > no one objects.
> 
> Do you have any specific reason for not including this one in 2.6.31?

Basically, it was too late for the merge window.

I think changes of this kind should really go in at the beginning of a merge
window, after spending a few weeks in linux-next so that no one is surprised.

It also needs an ACK from Greg.

> I guess you were thinking of keeping it together with your Runtime PM
> patches targeted for 2.6.32?
> 
> IMO, this patch is decoupled from Runtime PM. It will of course be
> used for Runtime PM on SuperH, but it can for instance also be used
> together with the clock framework.  On top of that, the patch is only
> adding code so it's very unlikely to cause any breakage.
> 
> If possible, I'd like this to be merged as early as possible since a
> lot of processor specific changes will depend on it. With this
> included in 2.6.31 I can easily build arch specific code for 2.6.32.
> Anything I can do to make that happen?
> 
> My top priority is Runtime PM for SuperH on top of your code, and I
> intend to post a prototype for SuperH before the PM Summit. It would
> be great to minimize the dependencies though, and including this in
> 2.6.31 would certainly help.

I'm going to add this patch to my linux-next branch shortly and if your 2.6.32
development is based on that branch (I'd recommend that anyway), there
shouldn't be any problems during the 2.6.32 merge window.

Thanks,
Rafael

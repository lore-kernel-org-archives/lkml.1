Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbYFWMjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbYFWMjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 08:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbYFWMjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 08:39:04 -0400
Received: from cpsmtpo-eml06.kpnxchange.com ([213.75.38.155]:37611 "EHLO
	cpsmtpo-eml06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753906AbYFWMjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 08:39:03 -0400
From: Frans Pop <elendil@planet.nl>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [Bug 10843] Display artifacts on XOrg logout with PAT kernel and VESA framebuffer
Date: Mon, 23 Jun 2008 14:38:59 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <200806142359.36613.elendil@planet.nl> <8B23168BCBB43B49A4C8EAB32D4B62F1061F3A82@orsmsx505.amr.corp.intel.com>
In-Reply-To: <8B23168BCBB43B49A4C8EAB32D4B62F1061F3A82@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231439.00899.elendil@planet.nl>
X-OriginalArrivalTime: 23 Jun 2008 12:39:01.0893 (UTC) FILETIME=[1D6CA350:01C8D52E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 June 2008, Siddha, Suresh B wrote:
> Frans Pop wrote:
> > On Saturday 14 June 2008, Rafael J. Wysocki wrote:
> > > Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=10843
> > > Subject       : Display artifacts on XOrg logout with PAT kernel
> > > and VESA framebuffer
> > > Submitter     : Frans Pop <elendil@planet.nl>
> > > Date          : 2008-05-31 14:04 (15 days old)
> > > References    : http://lkml.org/lkml/2008/6/7/206
> >
> > Yes. See also: http://lkml.org/lkml/2008/6/13/159
>
> Frans, With or without pat, in the recent kernels (like 2.6.26-rc4/rc5
> etc), ioremap() uses  UC- and PCI mmap of /sys/devices/pci.../resource
> (used by X) uses UC-
>
> And fb_mmap() also uses UC-.
>
> It's interesting that you don't see this artifact with "nopat".
> Essentially with or with out pat enabled, we use the same memory
> attributes. So depending on the MTRR setup (set by X server), effective
> memory attribute across different mappings should be same (which is UC-
> or WC with mtrr).

Any progress on this issue? It's still there with -rc7, but I doubt that 
comes as a surprise.

Has anyone tried to reproduce this? I would think that should be trivial.

Just as a summary:
- Intel 82945G/GZ graphics [8086:2772] (ICH7 based system)
- FB_VESA=y, FRAMEBUFFER_CONSOLE=y
- boot with vga=791
- Log in to X and KDE; I do need to really log in there are no artifacts
  if I exit X from the kdm login dialog
- artifacts show on logout

I doubt it's KDE related or even related to my specific graphics card.

It may well be related to what is or has been displayed on the display 
before logging out, so running some apps may make sense. Seems like I do 
see remnants of for example aptitude (Debian apt frontend) after I've run 
it in an X term (KDE's konsole).

Cheers,
FJP

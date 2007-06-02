Return-Path: <linux-kernel-owner+w=401wt.eu-S1760268AbXFBBQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760268AbXFBBQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 21:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757090AbXFBBQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 21:16:08 -0400
Received: from outbound-mail-65.bluehost.com ([69.89.21.25]:43645 "HELO
	outbound-mail-65.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752268AbXFBBQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 21:16:07 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Date: Fri, 1 Jun 2007 18:15:52 -0700
User-Agent: KMail/1.9.6
Cc: Andi Kleen <andi@firstfloor.org>, Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan> <200706011441.57149.jbarnes@virtuousgeek.org> <20070602010539.GA13512@linux-os.sc.intel.com>
In-Reply-To: <20070602010539.GA13512@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706011815.53065.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 1, 2007 6:05:39 Venki Pallipadi wrote:
> On Fri, Jun 01, 2007 at 02:41:57PM -0700, Jesse Barnes wrote:
> > On Friday, June 1, 2007 2:19:43 Andi Kleen wrote:
> > > And normally the MTRRs win, don't they (if I remember the table
> > > correctly) So if the MTRR says UC and PAT disagrees it might not
> > > actually help
> >
> > I just checked, yes the MTRRs win for UC types.  But it sounds like the
> > cases we're talking about are actually situations where there's no MTRR
> > coverage, so the default type is used.  The manual doesn't specifically
> > call out how memory using the default type interacts with PAT, but it may
> > well be that it stays uncached if the default type is uncached.  Again
> > that argues for fixing the MTRR mapping problem in some way.
>
> I feel, having a silent/transparent workaround is not a good idea. With
> that chances are BIOS bug will go unnoticed (having an error message in
> dmesg may not get noticed either). Probably we should just panic at boot
> with a
> detailed message about the e820 mtrr discrepancy (which can be logged as
> a BUG to BIOS provider) and suggest a temporary workaround of "mem=___".

That might be best, short of actually fixing the MTRRs...

Jesse



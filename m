Return-Path: <linux-kernel-owner+w=401wt.eu-S1761362AbXFDTSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362AbXFDTSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758940AbXFDTRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:17:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:30376 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758618AbXFDTRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:17:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,381,1175497200"; 
   d="scan'208";a="235413665"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Date: Mon, 4 Jun 2007 12:17:39 -0700
User-Agent: KMail/1.9.6
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan> <m1r6orwptz.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0706041420100.25811@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706041420100.25811@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706041217.39246.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 4, 2007 11:22 am Justin Piszcz wrote:
> On Mon, 4 Jun 2007, Eric W. Biederman wrote:
> > Jesse Barnes <jbarnes@virtuousgeek.org> writes:
> >> On Friday, June 1, 2007 2:19:43 Andi Kleen wrote:
> >>> And normally the MTRRs win, don't they (if I remember the table
> >>> correctly) So if the MTRR says UC and PAT disagrees it might not
> >>> actually help
> >>
> >> I just checked, yes the MTRRs win for UC types.  But it sounds
> >> like the cases we're talking about are actually situations where
> >> there's no MTRR coverage, so the default type is used.  The manual
> >> doesn't specifically call out how memory using the default type
> >> interacts with PAT, but it may well be that it stays uncached if
> >> the default type is uncached.  Again that argues for fixing the
> >> MTRR mapping problem in some way.
> >
> > Last I looked PAT can only demote not promote the type of a page,
> > except for the specific exception of UC to WC.
> >
> > Normally the default type is UC so putting a pat type of WB won't
> > help anything.  I may have missed some subtle detail but I remember
> > looking into this in some detail a while ago and coming to that
> > conclusion.
> >
> > It is the BIOS's responsibility to mark all usable memory as WB,
> > using the MTRRs.  If it doesn't it is a BIOS bug.
> >
> > Eric
>
> According to Intel it is not a BIOS bug but rather the media
> controller hub (MCH) uses memory for various purposes, outlined in
> their doc:
>
> From their response, it sounds like the kernel needs to setup the
> memory properly to deal with the MCH found in the 965 motherboards?
>
> From their e-mail:
>
> Note before continuing: Debian* Linux Operating System is not an
> officially, validated, tested Operating System for the Intel(R)
> Desktop Board DG965WH
> (see
> http://downloadcenter.intel.com/Product_Filter.aspx?ProductID=2375);
> moreover, we do confirm that "on a system that has 8 GB of system
> memory installed, it is not possible to use all of the installed
> memory due to system address space being allocated for other system
> critical functions." [qtd. on page 43 of the Technical Product
> Specification (see
> http://download.intel.com/design/motherbd/wh/D5600801US.pdf)].  Thus,
> the following suggestions are provided AS IS; we cannot guarantee the
> problem would be fixed afterwards:
>
> Therefore, they are NOT going to fix their BIOS-- and I have already
> received an e-mail from one or two people who are experiencing this
> problem, I presume it will only get worse.

That's a separate issue from the MTRR mapping though.  Regardless of the 
fact that the system needs some address space in its 8GB range reserved 
for I/O devices, the BIOS should properly setup the MTRRs to map all of 
*available* RAM.  So the person handling your bug report may have been 
confused into thinking that you were describing the former problem.

Jesse

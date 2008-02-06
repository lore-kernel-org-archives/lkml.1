Return-Path: <linux-kernel-owner+w=401wt.eu-S932146AbYBFHcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbYBFHcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 02:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758949AbYBFHcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 02:32:13 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47311 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758887AbYBFHcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 02:32:11 -0500
Date: Tue, 5 Feb 2008 23:26:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "pHilipp Zabel" <philipp.zabel@gmail.com>
Cc: "Matt Reimer" <mreimer@vpop.net>, linux-kernel@vger.kernel.org,
       johnpol@2ka.mipt.ru, szabolcs.gyurko@tlt.hu
Subject: Re: [PATCH] DS1WM: decouple host IRQ and INTR active state
 settings.
Message-Id: <20080205232652.895a5fbb.akpm@linux-foundation.org>
In-Reply-To: <74d0deb30801080021q63df5fcfw5ff3673ec9965d08@mail.gmail.com>
References: <1199627174.28826.11.camel@localhost.localdomain>
	<20080107151022.82901fcc.akpm@linux-foundation.org>
	<1199751203.26310.64.camel@bilbo.vpop.net>
	<74d0deb30801080021q63df5fcfw5ff3673ec9965d08@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 09:21:55 +0100 "pHilipp Zabel" <philipp.zabel@gmail.com> wrote:

> On Jan 8, 2008 1:13 AM, Matt Reimer <mreimer@vpop.net> wrote:
> > On Mon, 2008-01-07 at 15:10 -0800, Andrew Morton wrote:
> > > On Sun, 06 Jan 2008 14:46:14 +0100
> > > Philipp Zabel <philipp.zabel@gmail.com> wrote:
> > >
> > > > The DS1WM driver incorrectly infers the IAS bit (1-wire interrupt active
> > > > high) from IRQ settings. There are devices that have IAS=0 but still need
> > > > the IRQ to trigger on a rising edge. With this patch, machines with DS1WM
> > > > that need IAS=1 have to set .active_high=1 in the ds1wm_platform_data.
> >
> > > But no drivers are converted to set ds1wm_platform_data.active_high.  Won't
> > > IORESOURCE_IRQ_HIGHEDGE devices be broken by this change?
> >
> > Good point; I think you're right. I'd guess the other platforms that use
> > this driver are in the handhelds.org tree, but I've been out of the loop
> > a while. Philipp, is this the case?
> 
> Yes, I think so. I am only aware of four chips that include a DS1WM:
> HTC's ASIC3, PASIC2 and PASIC3 and Samsung SAMCOP.
> All of those drivers have yet to be submitted.
> 
> I will also apply this patch to hh.org CVS and fix up the devices that are
> affected by this change (aximx30, blueangel, magician, h1900, h4000,
> h5400, himalaya, hx4700, sable, universal).
> But none of those set IORESOURCE_IRQ_HIGHEDGE (most are just
> missing the IORESOURCE_IRQ_LOWEDGE flag). I am not sure about
> the status of rx3000 or other devices that might live in other trees.
> 
> I'm currently cleaning up the PASIC2/3 driver. After that I'll try to help
> cleaning up ASIC3 and finally getting it ready for submission.
> A whole load of devices in the hh.org tree depend on it.
> 

Guys, I'm thinking that by the time we actually need this patch in the
mainline tree, it may well be obsolete.  So I should drop the copy I have?



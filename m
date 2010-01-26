Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818Ab0AZSX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab0AZSX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 13:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809Ab0AZSXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 13:23:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:56310 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab0AZSXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 13:23:23 -0500
Message-ID: <4B5F32D4.5030605@kernel.org>
Date: Tue, 26 Jan 2010 10:22:12 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jeff Garrett <jeff@jgarrett.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Myron Stowe <myron.stowe@hp.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with pci=use_crs)
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>	<201001261348.59508.rjw@sisk.pl>	<201001261032.37053.bjorn.helgaas@hp.com>	<201001261902.13911.rjw@sisk.pl> <20100126101752.78196900@jbarnes-piketon>
In-Reply-To: <20100126101752.78196900@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2010 10:17 AM, Jesse Barnes wrote:
> On Tue, 26 Jan 2010 19:02:13 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>>> I'm quite concerned about this for .33 because I don't think Jeff's
>>> configuration (Dell desktop with Intel x58 and large graphics device)
>>> is unusual.
>>>
>>> The benefit of intel_bus.c is on machines with multiple IOHs, where we
>>> need to figure out which address ranges go to which IOHs so we can
>>> program downstream devices correctly.  But even there, _CRS should give
>>> us the information we need, so "pci=use_crs" should make these machines
>>> work.
>>>
>>> I think we should remove intel_bus.c before .33.  It's breaking boxes
>>> and we don't know how to fix it.  Even if we do find out how to fix it,
>>> I think we should move toward using _CRS instead, because that's what
>>> Windows uses and it's an easy way for the firmware to tell us about
>>> platform quirks.
>>
>> Perhaps it would be sufficient to make pci=use_crs the default and leave the
>> option to use intel_bus.c for whoever needs that?
> 
> We can't make use_crs the default w/o some more _CRS handling fixes
> (some firmwares have large lists we need to handle).
> 
> We can disable intel_bus.c though.  Yinghai, I'm inclined against the
> intel_bus.c approach at this point.  It seems unlikely we'll ever keep
> it up to date with new bridges, since its approach differs so much from
> how things are done in the Windows world, where the firmware provides
> a list of resources.  We'll always be playing catch up, and will
> probably be behind the firmware most of the time since the docs with
> the necessary info likely won't be public most of the time.
> 
> For 2.6.33 I'd like a minimal fix though, can you disable it for all
> but the multi-IOH case perhaps?

ok, we have one patch to enable that only with multi-IOH case.

YH

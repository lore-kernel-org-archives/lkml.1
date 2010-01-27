Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953Ab0A0VDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab0A0VDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 16:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934Ab0A0VDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 16:03:47 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:39397 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab0A0VDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 16:03:46 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with pci=use_crs)
Date: Wed, 27 Jan 2010 14:03:40 -0700
User-Agent: KMail/1.9.10
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Yinghai Lu <yinghai@kernel.org>,
       Jeff Garrett <jeff@jgarrett.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <201001271345.54454.bjorn.helgaas@hp.com> <alpine.LFD.2.00.1001271247450.3570@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001271247450.3570@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001271403.41955.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 January 2010 01:50:12 pm Linus Torvalds wrote:
> 
> On Wed, 27 Jan 2010, Bjorn Helgaas wrote:
> > 
> > Without intel_bus.c, we essentially assume config 1 all the time.
> > If we keep intel_bus.c and this patch for .33, things should work
> > for configs 1 and 4.  Adding support for config 4 is good.
> 
> Quite frankly, is there any major downside to just disabling/removing 
> intel_bus.c for 2.6.33? If we're not planning on having it in the long run 
> anyway - or even if we are, but we can't be really happy about the state 
> of it as it would be in 2.6.33, not using it at all seems to be the 
> smaller headache.
> 
> The machines that it helps are also the machines where you can fix things 
> up with 'use_csr', no? And they are pretty rare, and they didn't use to 
> work without that use_csr in 2.6.32 either, so it's not even a regression.
> 
> Am I missing something?

Only that when we added intel_bus.c, Yinghai reported that the reason
was because a machine had a broken _CRS, so "pci=use_crs" wouldn't help.

At the time, Windows hadn't been brought up on that box.  My
speculation is that by now, they've done that bringup and probably
fixed the _CRS issue, so it might work now.

If that's the case, we could drop intel_bus.c from .33 and just use
"pci=use_crs" on those boxes until we can figure out how to turn it
on automatically.

Bjorn

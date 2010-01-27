Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622Ab0A0U71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab0A0U71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472Ab0A0U70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:59:26 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:42605 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755429Ab0A0U7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:59:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=C4H8nfpflZelQa+rNvOC+HrWwKZXeXbt36S3jf04mWTeEGRs0f3MD8xKgci+hu+3ehjrc6gDSSmRisf7MpFgEdFEFEysDYE75GPfiZ1FAPJdTm33R0svraXawWBa0EmD;
Date: Wed, 27 Jan 2010 12:59:05 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai Lu <yinghai@kernel.org>,
       Jeff Garrett <jeff@jgarrett.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with
 pci=use_crs)
Message-ID: <20100127125905.17db320f@jbarnes-piketon>
In-Reply-To: <alpine.LFD.2.00.1001271247450.3570@localhost.localdomain>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
	<201001270945.17113.bjorn.helgaas@hp.com>
	<20100127085337.6ff06f6e@jbarnes-piketon>
	<201001271345.54454.bjorn.helgaas@hp.com>
	<alpine.LFD.2.00.1001271247450.3570@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 12:50:12 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
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

No that's the plan.  intel_bus.c was a good effort, but it's just too
different from what Windows does, and it'll always be behind.  We'll
disable it for 2.6.33 and try again to move to _CRS in 2.6.34 (but
fixing the problem with large numbers of _CRS resources this time).

-- 
Jesse Barnes, Intel Open Source Technology Center

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763574AbYEAU3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763574AbYEAU3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 16:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbYEAU3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 16:29:44 -0400
Received: from outbound-mail-157.bluehost.com ([67.222.39.37]:49809 "HELO
	outbound-mail-157.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756312AbYEAU3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 16:29:43 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Why such a big difference in init-time PCI resource call-paths (x86 vs x86_64) ?
Date: Thu, 1 May 2008 13:29:25 -0700
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       TJ <linux@tjworld.net>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1209571638.25051.54.camel@hephaestion.lan.tjworld.net> <20080501201111.GO20451@one.firstfloor.org> <481A23DE.6070905@zytor.com>
In-Reply-To: <481A23DE.6070905@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011329.25939.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 01, 2008 1:11 pm H. Peter Anvin wrote:
> Andi Kleen wrote:
> > On Thu, May 01, 2008 at 11:16:31AM -0700, Jesse Barnes wrote:
> >> On Wednesday, April 30, 2008 9:07 am TJ wrote:
> >>> In preparation for writing a Windows-style PCI resource allocation
> >>> strategy
> >>>
> >>>  - use all e820 gaps for IOMEM resources; top-down allocation -
> >>>
> >>> and thus giving devices with large IOMEM requirements more chance of
> >>> allocation in the 32-bit address space below 4GB (see bugzilla #10461),
> >
> > I tried that some time ago and it turned out that some systems have
> > mappings in holes and don't boot anymore when you fill the holes too
> > much. But that was only considering e820. if you do this it might work if
> > you do it really like windows and consider all resources, including ACPI.
>
> Yes, considering all possible reservation schemes is really critical
> here (including the magic knowledge of the legacy region).

Yeah, good point.  There's code to check for ACPI reserved regions when 
verifying MCFG space, so at least we're starting to do this...

Thanks,
Jesse


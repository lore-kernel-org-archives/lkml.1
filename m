Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbYFEUfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbYFEUfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 16:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759993AbYFEUew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 16:34:52 -0400
Received: from outbound-mail-131.bluehost.com ([67.222.39.21]:55153 "HELO
	outbound-mail-131.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759707AbYFEUev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 16:34:51 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] OLPC: pci: fix up PCI stuff so that PCI_GOANY supports OLPC
Date: Thu, 5 Jun 2008 13:34:32 -0700
User-Agent: KMail/1.9.9
Cc: Andres Salomon <dilinger@queued.net>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rmh@aybabtu.com
References: <20080605152914.6f4ca839@ephemeral> <20080605124220.5a6245ab.akpm@linux-foundation.org>
In-Reply-To: <20080605124220.5a6245ab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806051334.32260.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 05, 2008 12:42 pm Andrew Morton wrote:
> On Thu, 5 Jun 2008 15:29:14 -0400
>
> Andres Salomon <dilinger@queued.net> wrote:
> > Previously, one would have to specifically choose CONFIG_OLPC and
> > CONFIG_PCI_GOOLPC in order to enable PCI_OLPC.  That doesn't really
> > work for distro kernels, so this patch allows one to choose
> > CONFIG_OLPC and CONFIG_PCI_GOANY in order to build in OLPC support in
> > a generic kernel (as requested by Robert Millan).
> >
> > This also moves GOOLPC before GOANY in the menuconfig list.
> >
> > Finally, make pci_access_init return early if we detect OLPC hardware.
> > There's no need to continue probing stuff, and pci_pcbios_init
> > specifically trashes our settings (we didn't run into that before
> > because PCI_GOANY wasn't supported).
> >
> > It would be great if we could sneak this in for 2.6.26..  *cough*  :)
>
> It looks harmless enough.
>
> > ---
> >  arch/x86/Kconfig    |   11 +++++------
> >  arch/x86/pci/init.c |    3 ++-
> >  arch/x86/pci/olpc.c |    5 +++--
> >  arch/x86/pci/pci.h  |    2 +-
>
> But I never know whether arch/x86/pci is a Jesse thing or an Ingo
> thing.  Usual answer: it's an everyone thing and we all make a big mess ;)

Heh, yeah I've been taking quite a few x86 PCI patches (Ingo actually has a 
queue of them for me now), so I can pick this one up and put it in what I 
hope will be my final 2.6.26 pull request.

Jesse

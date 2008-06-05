Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYFETnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYFETnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 15:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYFETnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 15:43:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752393AbYFETnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 15:43:41 -0400
Date: Thu, 5 Jun 2008 12:42:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       tglx@linutronix.de, rmh@aybabtu.com,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] OLPC: pci: fix up PCI stuff so that PCI_GOANY supports
 OLPC
Message-Id: <20080605124220.5a6245ab.akpm@linux-foundation.org>
In-Reply-To: <20080605152914.6f4ca839@ephemeral>
References: <20080605152914.6f4ca839@ephemeral>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008 15:29:14 -0400
Andres Salomon <dilinger@queued.net> wrote:

> Previously, one would have to specifically choose CONFIG_OLPC and
> CONFIG_PCI_GOOLPC in order to enable PCI_OLPC.  That doesn't really
> work for distro kernels, so this patch allows one to choose
> CONFIG_OLPC and CONFIG_PCI_GOANY in order to build in OLPC support in
> a generic kernel (as requested by Robert Millan).
> 
> This also moves GOOLPC before GOANY in the menuconfig list.
> 
> Finally, make pci_access_init return early if we detect OLPC hardware.
> There's no need to continue probing stuff, and pci_pcbios_init
> specifically trashes our settings (we didn't run into that before
> because PCI_GOANY wasn't supported).
> 
> It would be great if we could sneak this in for 2.6.26..  *cough*  :)
> 

It looks harmless enough.

> ---
>  arch/x86/Kconfig    |   11 +++++------
>  arch/x86/pci/init.c |    3 ++-
>  arch/x86/pci/olpc.c |    5 +++--
>  arch/x86/pci/pci.h  |    2 +-

But I never know whether arch/x86/pci is a Jesse thing or an Ingo
thing.  Usual answer: it's an everyone thing and we all make a big mess ;)



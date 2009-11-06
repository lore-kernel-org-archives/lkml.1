Return-Path: <linux-kernel-owner+w=401wt.eu-S1759827AbZKFWAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827AbZKFWAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759769AbZKFWAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:00:35 -0500
Received: from outbound-mail-152.bluehost.com ([67.222.39.32]:58136 "HELO
	outbound-mail-152.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759691AbZKFWAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:00:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=eI4uKyyWm7JMarVoW+G/bOlCms8ZHAmtYjldszP2EQK1JSSSVTXSBvdW+0UILc9vPdNzw2eis6WjPx9HvsqVpkX6GGVId4QgW9kzabfyCUT7pbMxWO4eIVhyYVmRhrHN;
Date: Fri, 6 Nov 2009 14:00:42 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Sachin Sant <sachinp@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: Re: linux-next: Tree for November 5
Message-ID: <20091106140042.1e29d82b@jbarnes-piketon>
In-Reply-To: <200911051017.12135.bjorn.helgaas@hp.com>
References: <20091105190426.c9cadada.sfr@canb.auug.org.au>
	<4AF2AB23.9000907@in.ibm.com>
	<200911050931.04838.bjorn.helgaas@hp.com>
	<200911051017.12135.bjorn.helgaas@hp.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009 11:17:11 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> On Thursday 05 November 2009 09:31:04 am Bjorn Helgaas wrote:
> > On Thursday 05 November 2009 03:38:27 am Sachin Sant wrote:
> > > Today's next tree fails to build on i386 with
> > > 
> > > arch/x86/pci/built-in.o: In function `align_resource':
> > > arch/x86/pci/acpi.c:82: undefined reference to `__udivdi3'
> > > 
> > > The code in question was added by commit
> > > 03db42adfeeabe856dbb6894dd3aaff55838330a.
> > 
> > I'll look into this.  I did build and test a 32-bit x86 kernel, but
> > I built it on an x86_64 box using "linux32 make ...", which looks
> > like it used gcc 4.3.2.
> 
> Can you try the patch below, please?
> 
> 
> commit 00f16f0a2f4826eadec0565e4b454ab8bc7824cc
> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Date:   Thu Nov 5 10:03:57 2009 -0700
> 
>     x86/PCI: remove 64-bit division
>     
>     The roundup() caused a build error (undefined reference to
> `__udivdi3'). We're aligning to power-of-two boundaries, so it's
> simpler to just use ALIGN() anyway, which avoids the division.
>     
>     Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Applied with Randy's ack.  Thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center

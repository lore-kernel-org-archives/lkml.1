Return-Path: <linux-kernel-owner+w=401wt.eu-S1759047AbZIQScN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047AbZIQScN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZIQScL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:32:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44065 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbZIQScK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:32:10 -0400
Date: Thu, 17 Sep 2009 20:31:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] first round of PCI updates for 2.6.32
Message-ID: <20090917183120.GA1675@elte.hu>
References: <20090915132105.2fdd1d45@jbarnes-g45> <20090917173012.GA11155@elte.hu> <4AB275A1.8020005@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB275A1.8020005@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Ingo Molnar wrote:
> > * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > 
> >> The following changes since commit 332a3392188e0ad966543c87b8da2b9d246f301d:
> >>   Linus Torvalds (1):
> >>         Merge git://git.kernel.org/.../herbert/crypto-2.6
> > 
> > Since this went upstream -tip tests have been triggering nasty bootup 
> > crashes in the PCI code:
> > 
> > [    4.366174] initcall pci_proc_init+0x0/0x7a returned 0 after 976 usecs
> > [    4.373009] calling  pcie_portdrv_init+0x0/0x60 @ 1
> > [    4.378368] bus: 'pci_express': registered
> > [    4.382009] bus: 'pci': add driver pcieport-driver
> > [    4.387058] bus: 'pci': driver_probe_device: matched device 0000:00:0b.0 with driver pcieport-driver
> > [    4.396005] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:0b.0
> > [    4.404056] cpumask_of_node(255): node > nr_node_ids(16)
> 
> please check
> 
> [PATCH] x86/pci: retore 32bit to node0 as default node
> 
> to fix crash on 32bit system
> 
> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> index 5db96d4..e562ade 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
> @@ -646,9 +646,7 @@ int get_mp_bus_to_node(int busnum)
>  
>  #else /* CONFIG_X86_32 */
>  
> -static unsigned char mp_bus_to_node[BUS_NR] = {
> -	[0 ... BUS_NR - 1] = -1
> -};
> +static unsigned char mp_bus_to_node[BUS_NR];
>  
>  void set_mp_bus_to_node(int busnum, int node)
>  {

This seems to have done the trick, thanks!

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo

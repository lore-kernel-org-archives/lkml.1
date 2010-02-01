Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab0BAUh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 15:37:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:36058 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821Ab0BAUh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 15:37:56 -0500
Message-ID: <4B673B6B.6060404@kernel.org>
Date: Mon, 01 Feb 2010 12:36:59 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: IRQ regression messes up xseries 330 SCI resulting in apic=off
 - bisected to commit b9c61b70075c87a861262473
References: <201002011559.07869.trenn@suse.de>
In-Reply-To: <201002011559.07869.trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2010 06:59 AM, Thomas Renninger wrote:
> Hi,
> 
> booting a latest kernel on this machine results in:
> 
> PCI: PCI BIOS revision 2.10 entry at 0xfd61c, last bus=1
> PCI: Using configuration type 1 for base access bio: create slab <bio-0> at 0
> ACPI: SCI (IRQ30) allocation failed
> ACPI Exception: AE_NOT_ACQUIRED, Unable to install System Control Interrupt handler (20090903/evevent-161)
> ACPI: Unable to start the ACPI Interpreter
> 
> Later all kind of devices fail...
> 
...
> 
> 
> Attached are dmesg of an umodified broken 2.6.32 kernel and
> dmesg of a 2.6.32 kernel in which I reverted above patch (apic=verbose).
> The reverting needed some adjusting and I did this without understanding
> the code. I also attach the backported patch reverting above for 2.6.32
> which makes the machine work again (see dmesg attachment).
> This probably cannot go in, it would be great if someone could help
> finding a proper patch for mainline which makes the machine work again.
> (The ACPI irq, SCI, is meant to be on IRQ 30, rerouted from IRQ 3 via
> APIC source override table, which is rather odd/uncommon. Hope that helps)

ok, the root cause the SCI in on second ioapic....

will have a patch for it.

Thanks

Yinghai

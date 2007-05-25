Return-Path: <linux-kernel-owner+w=401wt.eu-S1759119AbXEYGME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119AbXEYGME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 02:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbXEYGLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 02:11:55 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41622 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbXEYGLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 02:11:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@ninex.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, ninex@o2.pl,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>,
       len.brown@intel.com
Subject: Re: [PATCH 2/2] msi:  Add support for the Intel chipsets that support MSI.
References: <200705122146.l4CLkH6q012322@fire-2.osdl.org>
	<m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6p5cyut.fsf_-_@ebiederm.dsl.xmission.com>
	<200705250738.57066.ak@suse.de>
Date: Fri, 25 May 2007 00:10:24 -0600
In-Reply-To: <200705250738.57066.ak@suse.de> (Andi Kleen's message of "Fri, 25
	May 2007 07:38:56 +0200")
Message-ID: <m17iqxcu27.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

> On Friday 25 May 2007 06:26:50 Eric W. Biederman wrote:
>> 
>> This patch is the result of a quick survey of the Intel chipset
>> documents.  I took a quick look in the document to see if the chipset
>> supported MSI and if so I looked through to find the vendor and device
>> id of device 0 function 0 of the chipset and added a quirk for that
>> device id if I it was not a duplicate. 
>
> It would be better to look for any PCI bridge. Sometimes there are
> different PCI bridges around (e.g. external PCI-X bridges on HT systems) 
> which might need own quirks

Maybe but pci-pci bridges should have no problems with MSI traffic
because at that level MSI is just a normal DMA write going upstream.

The AMD 8131 hypertransport to PCI-X bridge only failed because at the
connection to hypertransport it did not implement the hypertransport
msi mapping capability and the associated logic to convert an MSI
irq into a hypertranposrt IRQ.

I currently have a quirk that looks for any hypertransport msi mapping
capability and only enables MSI on the downstream bus of the bridge.

> Also in the x86 world Microsoft defined a FADT ACPI flag that MSI doesn't
> work for Vista. It might make sense to do
>
> if (dmi year >= 2007 && FADT.msi_disable not set) assume it works

Sounds reasonable to me.  If it happens to work reliably.

>> This patch should be safe.  The anecdotal evidence is that when dealing
>> with MSI the Intel chipsets just work.  If we find some buggy ones
>> changing the list won't be hard.
>
> The FADT bit should be probably checked anyways.

Sure if we have a way to check I have no problem, although I tend to
trust the hardware more.

Eric

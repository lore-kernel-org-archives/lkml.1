Return-Path: <linux-kernel-owner+w=401wt.eu-S1760300AbYGQPTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300AbYGQPTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbYGQPS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:18:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752636AbYGQPS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:18:58 -0400
Date: Thu, 17 Jul 2008 08:18:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       torvalds@linuxfoundation.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
In-Reply-To: <487EEAEB.4050009@firstfloor.org>
Message-ID: <alpine.LFD.1.10.0807170807040.2959@woody.linux-foundation.org>
References: <20080716214516.GA10777@basil.nowhere.org> <200807170011.12184.rjw@sisk.pl> <200807161633.01375.jbarnes@virtuousgeek.org> <487EEAEB.4050009@firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jul 2008, Andi Kleen wrote:
> 
> Hmm, but if you're dependent ACPI needs to go in first anyways, doesn't it?

Umm. The particular PART of ACPI you depend on needs to go in first, yes.

That's the whole point of topic branches. They allow you to separate out 
work to different areas, so that people who are interested in (say) the 
PCI-impacting ones can merge with one part, without having to wait for the 
other parts to stabilize.

> I don't think the ACPI tree is dependent on PCI at least. Or at least I didn't
> notice any problems in this area.

The PCI tree merged the suspend branch from the ACPI tree. You can see it 
by lookin gat the PCI merge in gitk:

	gitk dc7c65db^..dc7c65db

and roughly in the middle there you'll find Jesse's commit 53eb2fbe, in 
which he merges branch 'suspend' from Len's ACPI tree. 

So Jesse got these three commits:

	0e6859d... ACPI PM: Remove obsolete Toshiba workaround
	8d2bdf4... PCI ACPI: Drop the second argument of platform_pci_choose_state
	0616678... ACPI PM: acpi_pm_device_sleep_state() cleanup

from Len's tree. Then look at these three commits that I got when I 
actually merged from you:

	741438b... ACPI PM: Remove obsolete Toshiba workaround
	a80a6da... PCI ACPI: Drop the second argument of platform_pci_choose_state
	2fe2de5... ACPI PM: acpi_pm_device_sleep_state() cleanup

Look familiar? It's the same patches - just different commit ID's. You 
rebased and moved them around, so they're not really the "same" at all, 
and they don't show the shared history any more, and the fact that they 
were pulled earlier into the PCI tree (and then into mine).

This is what rebasing causes.

			Linus

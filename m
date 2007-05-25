Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbXEYFjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbXEYFjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 01:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbXEYFjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 01:39:04 -0400
Received: from mail.suse.de ([195.135.220.2]:59783 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbXEYFjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 01:39:02 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 2/2] msi:  Add support for the Intel chipsets that support MSI.
Date: Fri, 25 May 2007 07:38:56 +0200
User-Agent: KMail/1.9.6
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@ninex.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, ninex@o2.pl,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>,
       len.brown@intel.com
References: <200705122146.l4CLkH6q012322@fire-2.osdl.org> <m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com> <m1r6p5cyut.fsf_-_@ebiederm.dsl.xmission.com>
In-Reply-To: <m1r6p5cyut.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705250738.57066.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 May 2007 06:26:50 Eric W. Biederman wrote:
> 
> This patch is the result of a quick survey of the Intel chipset
> documents.  I took a quick look in the document to see if the chipset
> supported MSI and if so I looked through to find the vendor and device
> id of device 0 function 0 of the chipset and added a quirk for that
> device id if I it was not a duplicate. 

It would be better to look for any PCI bridge. Sometimes there are
different PCI bridges around (e.g. external PCI-X bridges on HT systems) 
which might need own quirks

Also in the x86 world Microsoft defined a FADT ACPI flag that MSI doesn't
work for Vista. It might make sense to do

if (dmi year >= 2007 && FADT.msi_disable not set) assume it works

> This patch should be safe.  The anecdotal evidence is that when dealing
> with MSI the Intel chipsets just work.  If we find some buggy ones
> changing the list won't be hard.

The FADT bit should be probably checked anyways.

-Andi

 

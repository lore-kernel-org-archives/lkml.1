Return-Path: <linux-kernel-owner+w=401wt.eu-S1763748AbXFBXeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763748AbXFBXeK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 19:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbXFBXd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 19:33:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:47801 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbXFBXd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 19:33:57 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] IO-APIC blacklist
Date: Sat, 2 Jun 2007 19:33:40 -0400
User-Agent: KMail/1.9.5
Cc: Tear <tarrqt@yahoo.com>, mingo@redhat.com, akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>
References: <105227.2990.qm@web63604.mail.re1.yahoo.com> <alpine.LFD.0.98.0706021400330.23741@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706021400330.23741@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706021933.40583.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>   -uhci_hcd 0000:00:1f.2: irq 19, io base 0x0000ff80	 # slow
>   +uhci_hcd 0000:00:1f.2: irq 17, io base 0x0000ff80	 # fine

nope, this function is on on hardware IRQ 19 in both cases.

it just looks like IRQ 17 in the ACPI case due to this:

ACPI: PCI Interrupt 0000:00:1f.2[D] -> GSI 19 (level, low) -> IRQ 17

Totally bogus?  Yes.
google "Kill IRQ compression"
But while I truly hate this particular hack and I've wanted it gone for a long time,
it doesn't appear to be related to the failure at hand -- it just makes
it more irritating to debug.

-Len

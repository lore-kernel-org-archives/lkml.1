Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbZBBWQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbZBBWQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZBBWQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:16:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598AbZBBWQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:16:27 -0500
Date: Mon, 2 Feb 2009 14:15:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>
Subject: Re: PCI PM: Restore standard config registers of all devices early
In-Reply-To: <200902022249.32452.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0902021413040.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <alpine.LFD.2.00.0902021241430.3247@localhost.localdomain> <1233608857.18767.113.camel@pasglop> <200902022249.32452.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Feb 2009, Rafael J. Wysocki wrote:
> 
> I think it would be easier to make ACPI allow us to run AML with interrupts
> off.

Well, I'd agree, except I have this strong memory of us having known bugs 
with ACPI turning hard-interrupts on again. Similarly, it uses mutexes etc 
that simply don't work with interrupts off and/or may turn them on again 
thanks to scheduling.

"Fixing" that seems not very easy. ACPI has a bad habit of being _really_ 
hard to fix in this area.

I do agree that _if_ we can just fix ACPI, we wouldn't have these issues, 
and we should  just call it with interrupts disabled with our existing 
code. But my previous email was a "maybe we can do it like this" kind of 
thing, which might allow us to use ACPI with none of the irq-off issues.

		Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbYKZWhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbYKZWhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 17:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYKZWho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 17:37:44 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:41543 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbYKZWhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 17:37:43 -0500
Date: Wed, 26 Nov 2008 17:37:29 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: acpi_evaluate_integer broken by design
In-reply-to: <20081126132050.cecb170b.akpm@linux-foundation.org>
X-X-Sender: lenb@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Machek <pavel@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.2.00.0811261729550.3895@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081125110508.GA1943@elf.ucw.cz>
 <20081126132050.cecb170b.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > Now I know why I had strange "scheduling in atomic" problems:
> > acpi_evaluate_integer() does malloc(..., irqs_disabled() ? GFP_ATOMIC
> > : GFP_KERNEL)... which is (of course) broken.
> 
> That is kinda weird.  When did this all start happening?

> > There's no way to reliably tell if we need GFP_ATOMIC or not from
> > code, this one for example fails to detect spinlocks held.

> Len, this looks like 2.6.28 material.  But given the poor quality of
> the changelog it is hard to be sure about this.  Why isn't everyone
> seeing these warnings?  What did Pavel do to provoke these alleged
> warnings?  Nobody knows...

I don't know know why pavel sees this and nobody else --
maybe something unusual he's doing with suspend?

The reason that the ACPI code is littered with bogus
irqs_disabled() ? GFP_ATOMIC : GFP_KERNEL)
is because, like boot, resume starts life with interrupts off.

I would prefer that resume and boot handle this the same way,
with system_state.  However, a few years ago when I suggested
using system_state for resume, Andrew thought that was a very
bad idea.  Andrew, do you still feel that way?

-Len

ps. I'll put this particular fix in my tree now.

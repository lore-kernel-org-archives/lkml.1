Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbZDBEPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbZDBEPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 00:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbZDBEPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 00:15:33 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:64450 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZDBEPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 00:15:32 -0400
Date: Thu, 02 Apr 2009 00:15:20 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Michael K. Johnson" <johnsonm@rpath.com>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Jordan Hargrave <Jordan_Hargrave@dell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [GIT PULL] x86 setup BIOS workarounds
In-reply-to: <200904011640.n31GeD0m008691@voreg.hos.anvin.org>
Message-id: <alpine.LFD.2.00.0904012357050.4657@localhost.localdomain>
References: <200904011640.n31GeD0m008691@voreg.hos.anvin.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +		/* ACPI 3.0 added the extended flags support.  If bit 0
> +		   in the extended flags is zero, we're supposed to simply
> +		   ignore the entry -- a backwards incompatible change! */
> +		if (size > 20 && !(buf.ext_flags & 1))
> +			continue;


At the risk of rushing to the defense of the ACPI spec...

This does not look like a backwards incompatible change to me.

In ACPI 2.0, size of 20 is always returned, and it would
be a Linux bug if we examined the undefined values after byte 19.

In ACPI 3.0, byte 20 is now defined.  So if the BIOS returns
a size >= 21, we are permitted to examine byte 20.

So I agree with the test above, but I do not agree with the comment.

thanks,
Len Brown, Intel Open Source Technology Center


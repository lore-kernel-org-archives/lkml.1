Return-Path: <linux-kernel-owner+w=401wt.eu-S934240AbZDBUXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934240AbZDBUXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 16:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761452AbZDBUXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 16:23:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43817 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbZDBUXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 16:23:36 -0400
Message-ID: <49D51B0C.3040307@zytor.com>
Date: Thu, 02 Apr 2009 13:07:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Michael K. Johnson" <johnsonm@rpath.com>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Jordan Hargrave <Jordan_Hargrave@dell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [GIT PULL] x86 setup BIOS workarounds
References: <200904011640.n31GeD0m008691@voreg.hos.anvin.org> <alpine.LFD.2.00.0904012357050.4657@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904012357050.4657@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
> 
> At the risk of rushing to the defense of the ACPI spec...
> 
> This does not look like a backwards incompatible change to me.
> 
> In ACPI 2.0, size of 20 is always returned, and it would
> be a Linux bug if we examined the undefined values after byte 19.
> 
> In ACPI 3.0, byte 20 is now defined.  So if the BIOS returns
> a size >= 21, we are permitted to examine byte 20.
> 
> So I agree with the test above, but I do not agree with the comment.
> 

If you look at the details of the ACPI spec, this flag is explicitly 
specified so that the BIOS can always return a fixed number of entries. 
  Now, a clever BIOS could of course skip these entries if the OS only 
requests 20 bytes -- but if it can do that, it could just equally well 
have *always* skipped those entries!  So the flag is useless.

However, the ACPI 3 spec is written so to actively lead people into 
implement things this way, and given BIOS developer track records, they 
would simply truncate the result to 20 bytes if the size passed in is 
20.  This, of course, means that it is now reporting an invalid entry, 
without retaining the information that it is invalid...

	-hpa

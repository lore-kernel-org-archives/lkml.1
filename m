Return-Path: <linux-kernel-owner+w=401wt.eu-S933980AbZDBTjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933980AbZDBTjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763501AbZDBTja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:39:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759666AbZDBTj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:39:29 -0400
Date: Thu, 2 Apr 2009 12:31:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Len Brown <lenb@kernel.org>
cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Michael K. Johnson" <johnsonm@rpath.com>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Jordan Hargrave <Jordan_Hargrave@dell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [GIT PULL] x86 setup BIOS workarounds
In-Reply-To: <alpine.LFD.2.00.0904020017480.4657@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904021227060.4130@localhost.localdomain>
References: <200904011640.n31GeD0m008691@voreg.hos.anvin.org> <alpine.LFD.2.00.0904011115210.4130@localhost.localdomain> <alpine.LFD.2.00.0904020017480.4657@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Apr 2009, Len Brown wrote:
> 
> Yes, this expects old BIOS to always return 20.

Do you have any reason to expect that all BIOS'es are bug-free in this 
area? 

That would be a first.

We already check for other error cases where the BIOS didn't do the right 
thing in other ways in its e820 routine, or clobbered the wrogn registers 
or whatever. Why would you expect that the return value would always be 
ok?

> No, it does not expect old BIOS to have any particular value
> in buf.ext_flags -- since that is examined only for size > 20.

The point is, that expectation that the BIOS returns 20 seems very 
unreasonable. BIOS writers tend to have been on pain medication for so 
long that they can hardly remember their own name, much less actually make 
sure they follow all the documentation.

Now, if Windows has actually _depended_ on the right return value since 
Win95, that would be a good, strong argument.

Because that's the only case where we can pretty much depend on BIOS 
writers get things right - if Windows doesn't boot when they get it wrong. 
As far as I can tell, that has always been the only real quality assurance 
for most BIOS'es.

			Linus

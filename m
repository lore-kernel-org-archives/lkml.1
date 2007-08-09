Return-Path: <linux-kernel-owner+w=401wt.eu-S966715AbXHIRBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966715AbXHIRBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966573AbXHIRBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:01:21 -0400
Received: from ns1.suse.de ([195.135.220.2]:53967 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966582AbXHIRBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:01:18 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "huang ying" <huang.ying.caritas@gmail.com>
Subject: Re: [PATCH 5/5] x86_64 EFI support -v3: EFI document
Date: Thu, 9 Aug 2007 19:01:10 +0200
User-Agent: KMail/1.9.6
Cc: "Etienne Lorrain" <etienne_lorrain@yahoo.fr>, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, "H. Peter Anvin" <hpa@zytor.com>
References: <183884.85434.qm@web26915.mail.ukl.yahoo.com> <200708091251.21726.ak@suse.de> <851fc09e0708090709s4f4fbbf9r91a7300a773f985a@mail.gmail.com>
In-Reply-To: <851fc09e0708090709s4f4fbbf9r91a7300a773f985a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708091901.11146.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 August 2007 16:09:23 huang ying wrote:
> On 8/9/07, Andi Kleen <ak@suse.de> wrote:
> > There is really no 32bit entry point today usable for external users. Or rather
> > it might by chance work today, but if we change the zero page (and there
> > is no guarantee it'll not be changed). I can pretty much guarantee it'll
> > be changed at some point. And you'll break if you use it.
> 
> Yes, there is no official 32bit external entry point. But on EFI
> platform, the 16bit entry point can not be used because there is no
> 16bit BIOS call available. So, I think it is necessary to define a
> 32bit external entry point.

Ok. How do you collect all the data in the zero page then?
There's much more in there than just the memory map.

Anyways for EFI the best way is probably to define a EFI entry
point that does the same work as the real mode code today just
using EFI services.

And for kexec :- well need a proper protocol.

> 
> > kexec can use the 32bit entry, but only because it is in tree so it can be fixed
> > up for any changes.
> 
> The kexec uses the 32bit entry point in a user space tool named
> kexec-tools, not in the kernel.

Ah i didn't realize this. Ok then kexec is also quite broken.
Somehow this must have been missed this fundamental flaw when this code was 
reviewed.

> 
> > If you want to use it you would need to define some versionable protocol
> > first similar to the real mode boot protocol. That would require some work
> > and some thought to make sure it is forwards and backwards compatible.
> 
> I think at least the following should be done to make it a external
> boot protocol.
> 
> 1. A version number field should be added.
> 2. The pointers (especially these come from firmware) should be 64bit
> to make the entry point can be used for both 32bit and 64bit platform.

32bit pointers are not too bad; it needs to be all physical anyways
because kernel virtual mapping can change any time.

> 3. More complete and formal document.
> 
> Can you kindly tell me what's more should be done?

It's a minimum start. But at least for EFI I still think it's better
to just move that code back into the kernel. Just cleanly separated.

-Andi

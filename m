Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbXE3XKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbXE3XKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757665AbXE3XKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:10:00 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:48628 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551AbXE3XJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:09:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qbaqnpfR4y8V9Qq5k7hLzoM4ODzqRcWPDRsX5BwjxHRntUJfySjUyvYOh/3r58fqIGU33GckwGRuhI/SW/0lgVsAohtui3YhSC1UHoiaeCg0A6PrOL5fzFHrH/XvN98UqfzoTjPnllnfxAix22WQ+DpbvWD1pVlODLh//xZxWYg=
Message-ID: <21d7e9970705301609w88a9f80t20f83806003f699e@mail.gmail.com>
Date: Thu, 31 May 2007 09:09:58 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: GFP_DMA32 and PAE x86 machines
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Linus Torvalds" <torvalds@osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200705310024.25937.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21d7e9970705301410m16ded9esdf7a49371c60a155@mail.gmail.com>
	 <465DECD7.8030104@zytor.com>
	 <21d7e9970705301507o2a89e824xdc6a980e8dbedaaf@mail.gmail.com>
	 <200705310024.25937.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/31/07, Andi Kleen <ak@suse.de> wrote:
> On Thursday 31 May 2007 00:07:45 Dave Airlie wrote:
> > Depending on split all lowmem is below 1GB which isn't exactly
> > optimal, I'd llike all 4GB for DMA.
>
> Well it would be for a quite specialized limited use case:
> - Memory the kernel doesn't need to map (after all kmap is evil)
> - You need more than 500MB or so.
> - 32bit kernel and user cannot run 64bit kernel
> - Machine has >3GB of RAM
>
> Is there clear evidence that is a common issue? If it is just a "would
> be nice to have in theory" the cost of doing a GFP_DMA32 for i386 would be
> probably not worth doing it. If it's a common issue it might be
> considered, although the "here's a nickle. buy yourself a 64bit CPU"
> strategy would also sound attractive.
>
> Please give a very very strong rationale why you want it. Did you actually
> run into such a situation yourself yet?

Funnily enough I have just today with an app I have which uses 1.2GB
of textures :-)

we are currently using GFP_DMA32 in the TTM allocator code, however
what I really want on x86 non-PAE is GFP_HIGHMEM (as DMA32 does
nothing) however on x86-PAE I don't want that I want a real GFP_DMA32,
and on x86-64 I want the current GFP_DMA32,

Therein lies my problems, the API sucks, but I suppose the DRM TTM is
a special use case (AGP is the same) and I'll accept the fact that can
just make it my own problem, my current solution would be to screw PAE
machines giving them 1GB only and let non-PAE access all 4GB.

Dave.

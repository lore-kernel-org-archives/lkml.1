Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbXLUQcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbXLUQcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 11:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbXLUQcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 11:32:07 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:52540 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbXLUQcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 11:32:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:reply-to:to:cc:subject:in-reply-to:message-id:references:user-agent:mime-version:content-type;
        b=xsXRvw9QdOSxbE4tgMNzLTsuDROYhIe97IRj4jo4sNcEsS23o0sS6ZyR2a+qP5zDAJ0p9/tDxNaqSn/+lHxQmPL5m/aj7IBi7ePBrkt3vPZ9M3D+IPS7TwDKlnwg5pBl5lMyRbxl8FDtK9opA8BajOZ9qCyVawRp12VwXR+wFSw=
Date: Fri, 21 Dec 2007 11:31:53 -0500 (EST)
From: Parag Warudkar <parag.warudkar@gmail.com>
X-X-Sender: parag@mini.warudkars.net
Reply-To: parag.warudkar@gmail.com
To: Andi Kleen <ak@suse.de>
cc: Parag Warudkar <parag.warudkar@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] x86: Fix DMI out of memory problems
In-Reply-To: <20071221134111.GB8222@bingen.suse.de>
Message-ID: <alpine.LRH.1.00.0712211006290.18697@mini.warudkars.net>
References: <Pine.LNX.4.64.0712181848430.3663@mini.warudkars.net> <20071221134111.GB8222@bingen.suse.de>
User-Agent: Alpine 1.00 (LRH 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 Dec 2007, Andi Kleen wrote:

> 
> FWIW the ff tree has patches to allow "really early allocation" now.
> They could be used for this. I didn't implement that for i386 though,
> so that would still need some variant of your patch.

Just to clarify -The allocation failure currently happens only on x86_64 - 
on i386 it uses alloc_bootmem and does not fail.

Regardless though this patch is a good idea for both i386 and x86_64 - 
there is no point in repeatedly allocating memory for large empty strings 
no matter where it comes from, which was the point of this patch.

> 
> Disadvantage right now: e820 memory allocation currently rounds to pages
> always. I intend to fix that though because it also wastes memory
> with the memnodemap for once.
> 
So looks like currently we have to at least use 4K with these patches - 
that would be at least 8 times more than what is actually used after this 
patch unless we also fit in some other early alloc in this 4k. I will keep 
an eye on the ff tree though - when you get to fix it we can switch all early allocs to use it.

Thanks

Parag

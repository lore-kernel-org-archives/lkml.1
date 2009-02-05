Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbZBEJa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbZBEJa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 04:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbZBEJaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 04:30:09 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:38393 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbZBEJaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 04:30:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Fk6xUazk9aglHNTPD8SWofcIhjEzoKxq8rHPpkzC24BOqMguXcEpWbZEdI22xyfuxy
         As7+5ajVmst3uNXTu4C5eo1KpZcrH/Cwd4pbcMPLp7E1uLR8rWZeDgLH9sK2UX7GpEg5
         5Z0kAtDXSKMsZjZNRb6kalS40O2I4sfedw2Xk=
MIME-Version: 1.0
In-Reply-To: <200811201405.06811.david-b@pacbell.net>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
	 <200811201347.46355.david-b@pacbell.net>
	 <8bd0f97a0811201357g1ffeb7d3pfad6e178fb20050e@mail.gmail.com>
	 <200811201405.06811.david-b@pacbell.net>
Date: Thu, 5 Feb 2009 17:30:06 +0800
X-Google-Sender-Auth: 5390efd639528437
Message-ID: <386072610902050130k27c6d7far752ac49183bf36ae@mail.gmail.com>
Subject: Re: [PATCH 01/16] Blackfin SPI Driver: ensure cache coherency before 
	doing DMA
From: Bryan Wu <cooloney@kernel.org>
To: David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Vitja Makarov <vitja.makarov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 6:05 AM, David Brownell <david-b@pacbell.net> wrote:
> On Thursday 20 November 2008, Mike Frysinger wrote:
>> On Thu, Nov 20, 2008 at 16:47, David Brownell wrote:
>
>> > Basically, dma_map_single(), dma_unmap_single() ... and
>> > remember that the caller may have done the mappings for
>> > you already.
>>
>> these arent required to provide coherent memory right ?  if that's the
>> case, i can take a look at getting things updated.
>
> Right.  If caller provides dma-coherent memory to you, they
> must also have provided the DMA addresses the controller
> driver should be using ... so you won't need dma mapping
> calls on those paths.
>
>
>> > It'd be nice if one of patches snuck in a comment on that
>> > point:  "Full duplex only works for non-DMA transfers."
>> > Same rationale:  you may know this hardware inside out,
>> > but the next person won't.
>>
>> well, hopefully if they dont know they wont be touching the driver ;).
>>  i'll add a comment in this code chunk.  thanks for the feedback.
>
> The way it usually works is someone observes a problem and
> then starts experimenting on relevant code.  So they learn
> a bit while debugging ... and code authors/maintainers need
> to keep that learning curve from being too steep.  ;)
>
> - Dave
>
>

Hi Dave,

As you acked this patchset, is that possible to merge it?
Or need Andrew to keep them in -mm for a while.

Thanks
-Bryan

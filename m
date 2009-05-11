Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbZEKXsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbZEKXsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758935AbZEKXsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:48:42 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:50322 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbZEKXsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:48:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eadeu7rfsElTinPXUXTzGSYooaWZoEkywediziMbz1WVROTG/MkNqBtN8vySMuaksm
         TY1MW0/7C2weIJ9I6ZcQF6/yj46cHwlslQOS4qcI2bSonSh/WBxrBHnRBOgRZknc+m1A
         4PK4Tysc7VETjhJGzDdUX2mTRPqdaFXSYTg94=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0905111229540.23739@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905091544470.6884@chino.kir.corp.google.com>
	 <20090511162900.f372edd1.minchan.kim@barrios-desktop>
	 <alpine.DEB.2.00.0905110138160.24726@chino.kir.corp.google.com>
	 <28c262360905110212j9867b79wd8d90b16f6f196be@mail.gmail.com>
	 <28c262360905110421g1b079f2cr798ca95adfb8ee45@mail.gmail.com>
	 <20090511133840.GA11624@csn.ul.ie>
	 <28c262360905110700p68f3de35xf0a1d52d2ccfd968@mail.gmail.com>
	 <alpine.DEB.2.00.0905111229540.23739@chino.kir.corp.google.com>
Date: Tue, 12 May 2009 08:48:42 +0900
Message-ID: <28c262360905111648p21628f74u37daf0b028fe3fca@mail.gmail.com>
Subject: Re: [patch -mmotm] mm: invoke oom killer for __GFP_NOFAIL
From: Minchan Kim <minchan.kim@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 4:32 AM, David Rientjes <rientjes@google.com> wrote:
> On Mon, 11 May 2009, Minchan Kim wrote:
>
>> But this patch increases the probability of innocent task killing.
>> Is GFP_NOFAIL's early bailout more important than killing of innocent task ?
>>
>
> __GFP_NOFAIL's bailout is, by definition, a bug in the page allocator and
> this patch fixes it.
>

What I mean is If fortunately other process have a lot of memory is
exited while looping, __GFP_NOFAIL can return.
I have no objection about your patch.
Just, I have a concern of killing innocent task.

As Mel and Andrew pointed out, fundamentally, __GFOP_NOFAIL and
high-order allocation itself is bad code.
Okay. we have to insert WARN_ON properly.

Thanks for good contribution. :)

-- 
Kinds regards,
Minchan Kim

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbYIYWmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbYIYWmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 18:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYIYWl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 18:41:56 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:42319 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbYIYWlz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 18:41:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uSoxGWGG68phOHQxf3XbCroyTvfbMw1DkXzjymy5UT4yYxTEKM2swn9lV5hAxf+RT2
         PLv2vr1+1NS510M9+XHuD7JMtYX4rzBHJ866DiFnSN895/FpAvs6AcJVO9lqQu1xt0D9
         XLemSV/ONXyMGcd88R7SUuCJPWug5JUZz9S5Q=
Message-ID: <21d7e9970809251541o5911ffefqeeb343e69b7d0871@mail.gmail.com>
Date: Fri, 26 Sep 2008 08:41:53 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "=?ISO-8859-1?Q?Thomas_Hellstr=F6m?=" <thomas@tungstengraphics.com>
Subject: Re: [patch] mm: pageable memory allocator (for DRM-GEM?)
Cc: "Keith Packard" <keithp@keithp.com>, "Nick Piggin" <npiggin@suse.de>,
       "eric@anholt.net" <eric@anholt.net>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "hch@infradead.org" <hch@infradead.org>,
       "airlied@linux.ie" <airlied@linux.ie>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       "Linux Memory Management List" <linux-mm@kvack.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48DBB0B3.2010500@tungstengraphics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080923091017.GB29718@wotan.suse.de>
	 <48D8C326.80909@tungstengraphics.com>
	 <20080925001856.GB23494@wotan.suse.de>
	 <48DB3B88.7080609@tungstengraphics.com>
	 <1222353487.4343.205.camel@koto.keithp.com>
	 <48DBB0B3.2010500@tungstengraphics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 1:39 AM, Thomas Hellström
<thomas@tungstengraphics.com> wrote:
> Keith Packard wrote:
>>
>> On Thu, 2008-09-25 at 00:19 -0700, Thomas Hellström wrote:
>>
>>>
>>>  If data is
>>> dirtied in VRAM or the page(s) got discarded
>>>  we need new pages and to set up a copy operation.
>>>
>>
>> Note that this can occur as a result of a suspend-to-memory transition
>> at which point *all* of the objects in VRAM will need to be preserved in
>> main memory, and so the pages aren't really 'freed', they just don't
>> need to have valid contents, but the system should be aware that the
>> space may be needed at some point in the future.
>>
>>
>
> Actually, I think the pages must be allowed to be freed, and that we don't
> put a requirement on "pageable"  to keep
> swap-space slots for these pages. If we hit an OOM-condition during
> suspend-to-memory that's bad, but let's say we
> required "pageable" to keep swap space slots for us, the result would
> perhaps be that another device wasn't able to suspend, or a user-space
> program was killed due to lack of swap-space prior to suspend.
>
> I'm not really sure what's the worst situation, but my feeling is that we
> should not require swap-space to be reserved for VRAM, and abort the suspend
> operation if we hit OOM. That would, in the worst case, mean that people
> with non-UMA laptops and a too small swap partition would see their battery
> run out much quicker than they expected...
>

You can't fail suspend, it just doesn't work like that. The use case
is close laptop
shove in bag, walk away. Having my bag heat up and the laptop inside
not suspended
isn't the answer ever.

So with that in mind, I think we either a) keep some backing pages
around, or b) make object
file backed so if the swap space fills up we can back out to the file objects.

Dave.

> /Thomas
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbZICCA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbZICCA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 22:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbZICCA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 22:00:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbZICCA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 22:00:56 -0400
Message-ID: <4A9F230F.40707@redhat.com>
Date: Wed, 02 Sep 2009 21:59:43 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Mark Lord <lkml@rtr.ca>, Michael Tokarev <mjt@tls.msk.ru>, david@lang.hm,
       Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       NeilBrown <neilb@suse.de>, Rob Landley <rob@landley.net>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
References: <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz> <alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm> <4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru> <20090830163513.GA25899@infradead.org> <4A9BCCEF.7010402@redhat.com> <20090831131626.GA17325@infradead.org> <4A9BCDFE.50008@rtr.ca> <20090831132139.GA5425@infradead.org>
In-Reply-To: <20090831132139.GA5425@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2009 09:21 AM, Christoph Hellwig wrote:
> On Mon, Aug 31, 2009 at 09:19:58AM -0400, Mark Lord wrote:
>>> In my opinion even that is too weak.  We know how to control the cache
>>> settings on all common disks (that is scsi and ata), so we should always
>>> disable the write cache unless we know that the whole stack (filesystem,
>>> raid, volume managers) supports barriers.  And even then we should make
>>> sure the filesystems does actually use barriers everywhere that's needed
>>> which failed at for years.
>> ..
>>
>> That stack does not know that my MD device has full battery backup,
>> so it bloody well better NOT prevent me from enabling the write caches.
>
> No one is going to prevent you from doing it.  That question is one of
> sane defaults.  And always safe, but slower if you have advanced
> equipment is a much better default than usafe by default on most of
> the install base.
>

Just to add some support to this, all of the external RAID arrays that I know of 
normally run with write cache disabled on the component drives. In addition, 
many of them will disable their internal write cache if/when they detect that 
they have lost their UPS.

I think that if we had done this kind of sane default earlier for MD levels that 
do not handle barriers, we would not have left some people worried about our 
software RAID.

To be clear, if a sophisticated user wants to override this default, that should 
be supported. It is not (in my opinion) a safe default behaviour.

Ric


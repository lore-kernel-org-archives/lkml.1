Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbZHaNUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbZHaNUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 09:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbZHaNT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 09:19:59 -0400
Received: from rtr.ca ([76.10.145.34]:37047 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbZHaNT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 09:19:58 -0400
Message-ID: <4A9BCDFE.50008@rtr.ca>
Date: Mon, 31 Aug 2009 09:19:58 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
Cc: Ric Wheeler <rwheeler@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>,
       david@lang.hm, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>, NeilBrown <neilb@suse.de>,
       Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
References: <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com> <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz> <alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm> <4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru> <20090830163513.GA25899@infradead.org> <4A9BCCEF.7010402@redhat.com> <20090831131626.GA17325@infradead.org>
In-Reply-To: <20090831131626.GA17325@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Aug 31, 2009 at 09:15:27AM -0400, Ric Wheeler wrote:
>>> While most common filesystem do have barrier support it is:
>>>
>>>   - not actually enabled for the two most common filesystems
>>>   - the support for write barriers an cache flushing tends to be buggy
>>>     all over our software stack,
>>>
>> Or just missing - I think that MD5/6 simply drop the requests at present.
>>
>> I wonder if it would be worth having MD probe for write cache enabled & 
>> warn if barriers are not supported?
> 
> In my opinion even that is too weak.  We know how to control the cache
> settings on all common disks (that is scsi and ata), so we should always
> disable the write cache unless we know that the whole stack (filesystem,
> raid, volume managers) supports barriers.  And even then we should make
> sure the filesystems does actually use barriers everywhere that's needed
> which failed at for years.
..

That stack does not know that my MD device has full battery backup,
so it bloody well better NOT prevent me from enabling the write caches.

In fact, MD should have nothing to do with that.  I do like/prefer the
way that XFS currently does it:  disables barriers and logs the event,
but otherwise doesn't try to enforce policy upon me from kernel space.

Cheers

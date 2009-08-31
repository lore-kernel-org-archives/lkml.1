Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbZHaNWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbZHaNWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 09:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbZHaNWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 09:22:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbZHaNWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 09:22:22 -0400
Message-ID: <4A9BCEA8.9080206@redhat.com>
Date: Mon, 31 Aug 2009 09:22:48 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090806 Fedora/3.0-3.8.b3.fc12 Thunderbird/3.0b3
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Michael Tokarev <mjt@tls.msk.ru>, david@lang.hm,
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
References: <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com> <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz> <alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm> <4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru> <20090830163513.GA25899@infradead.org> <4A9BCCEF.7010402@redhat.com> <20090831131626.GA17325@infradead.org>
In-Reply-To: <20090831131626.GA17325@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2009 09:16 AM, Christoph Hellwig wrote:
> On Mon, Aug 31, 2009 at 09:15:27AM -0400, Ric Wheeler wrote:
>>> While most common filesystem do have barrier support it is:
>>>
>>>    - not actually enabled for the two most common filesystems
>>>    - the support for write barriers an cache flushing tends to be buggy
>>>      all over our software stack,
>>>
>>
>> Or just missing - I think that MD5/6 simply drop the requests at present.
>>
>> I wonder if it would be worth having MD probe for write cache enabled&
>> warn if barriers are not supported?
>
> In my opinion even that is too weak.  We know how to control the cache
> settings on all common disks (that is scsi and ata), so we should always
> disable the write cache unless we know that the whole stack (filesystem,
> raid, volume managers) supports barriers.  And even then we should make
> sure the filesystems does actually use barriers everywhere that's needed
> which failed at for years.
>

I was thinking about that as well. Having us disable the write cache when we 
know it is not supported (like in the MD5 case) would certainly be *much* safer 
for almost everyone.

We would need to have a way to override the write cache disabling for people who 
either know that they have a non-volatile write cache (unlikely as it would 
probably be to put MD5 on top of a hardware RAID/external array, but some of the 
new SSD's claim to have non-volatile write cache).

It would also be very useful to have all of our top tier file systems enable 
barriers by default, provide consistent barrier on/off mount options and log a 
nice warning when not enabled....

ric


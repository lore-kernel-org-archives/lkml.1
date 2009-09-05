Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972AbZIENlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbZIENlp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 09:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZIENlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 09:41:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbZIENln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 09:41:43 -0400
Message-ID: <4AA26A4D.5090309@redhat.com>
Date: Sat, 05 Sep 2009 09:40:29 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Christoph Hellwig <hch@infradead.org>,
       Michael Tokarev <mjt@tls.msk.ru>, david@lang.hm,
       Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       NeilBrown <neilb@suse.de>, Rob Landley <rob@landley.net>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: wishful thinking about atomic, multi-sector or full MD stripe
 width, writes in storage
References: <20090828064449.GA27528@elf.ucw.cz>	<20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz>	<alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm>	<4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru>	<20090830163513.GA25899@infradead.org> <4A9BCCEF.7010402@redhat.com>	<20090831131626.GA17325@infradead.org> <4A9BCDFE.50008@rtr.ca>	<20090831132139.GA5425@infradead.org> <4A9F230F.40707@redhat.com>	<m3ab1cp9ii.fsf@intrepid.localdomain> <4A9FA5F2.9090704@redhat.com>	<m3ljkwnoct.fsf@intrepid.localdomain> <4A9FC9B3.1080809@redhat.com> <m3ab1cnn7y.fsf@intrepid.localdomain> <4A9FCF6B.1080704@redhat.com> <4AA184D7.1010502@rtr.ca> <4AA186B0.5090905@redhat.com> <4AA26055.2090400@rtr.ca>
In-Reply-To: <4AA26055.2090400@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2009 08:57 AM, Mark Lord wrote:
> Ric Wheeler wrote:
>> On 09/04/2009 05:21 PM, Mark Lord wrote:
> ..
>>> How about instead, *fixing* the MD layer to properly support barriers?
>>> That would be far more useful, productive, and better for end-users.
> ..
>> Fixing MD would be great - not sure that it would end up still faster 
>> (look at md1 devices with working barriers with compared to md1 with 
>> write cache disabled).
> ..
>
> There's no inherent reason for it to be slower, except possibly
> drives with b0rked FUA support.
>
> So the first step is to fix MD to pass barriers to the LLDs
> for most/all RAID types.
> Then, if it has performance issues, those can be addressed
> by more application of little grey cells.  :)
>
> Cheers

The performance issue with MD is that the "simple" answer is to not only 
pass on those downstream barrier ops, but also to block and wait until 
all of those dependent barrier ops complete before ack'ing the IO.

When you do that implementation at least, you will see a very large 
performance impact and I am not sure that you would see any degradation 
vs just turning off the write caches.

Sounds like we should actually do some testing and actually measure, I 
do think that it will vary with the class of device quite a lot just 
like we see with single disk barriers vs write cache disabled on SAS vs 
S-ATA, etc...

ric


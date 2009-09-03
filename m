Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbZICXur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbZICXur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 19:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756574AbZICXuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 19:50:46 -0400
Received: from khc.piap.pl ([195.187.100.11]:50192 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbZICXup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 19:50:45 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Lord <lkml@rtr.ca>,
       Michael Tokarev <mjt@tls.msk.ru>, david@lang.hm,
       Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       NeilBrown <neilb@suse.de>, Rob Landley <rob@landley.net>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: wishful thinking about atomic, multi-sector or full MD stripe width, writes in storage
References: <20090828064449.GA27528@elf.ucw.cz>
	<20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz>
	<alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm>
	<4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru>
	<20090830163513.GA25899@infradead.org> <4A9BCCEF.7010402@redhat.com>
	<20090831131626.GA17325@infradead.org> <4A9BCDFE.50008@rtr.ca>
	<20090831132139.GA5425@infradead.org> <4A9F230F.40707@redhat.com>
	<m3ab1cp9ii.fsf@intrepid.localdomain> <4A9FA5F2.9090704@redhat.com>
	<m3ljkwnoct.fsf@intrepid.localdomain> <4A9FC9B3.1080809@redhat.com>
	<m3ab1cnn7y.fsf@intrepid.localdomain> <4A9FCF6B.1080704@redhat.com>
Date: Fri, 04 Sep 2009 01:50:42 +0200
In-Reply-To: <4A9FCF6B.1080704@redhat.com> (Ric Wheeler's message of "Thu, 03
	Sep 2009 10:15:07 -0400")
Message-ID: <m33a73oael.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler <rwheeler@redhat.com> writes:

> The whole thread above is about software MD using commodity drives
> (S-ATA or SAS) without battery backed write cache.

Yes. However, you mentioned external RAID arrays disable disk caches.
That's why I asked if they are using SATA or SCSI/etc. disks, and if
they have battery-backed cache.

> Also, when you enable the write cache (MD or not) you are buffering
> multiple MB's of data that can go away on power loss. Far greater
> (10x) the exposure that the partial RAID rewrite case worries about.

The cache is flushed with working barriers. I guess it should be
superior to disabled WB cache, in both performance and expected disk
lifetime.
-- 
Krzysztof Halasa

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbZE2RHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbZE2RHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 13:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756126AbZE2RHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 13:07:43 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46308 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbZE2RHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 13:07:42 -0400
Date: Fri, 29 May 2009 19:07:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "david@fromorbit.com" <david@fromorbit.com>,
       "hch@infradead.org" <hch@infradead.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "jack@suse.cz" <jack@suse.cz>,
       "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "damien.wyart@free.fr" <damien.wyart@free.fr>
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
Message-ID: <20090529170742.GI11363@kernel.dk>
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com> <4A1E9D0B.4090402@gmail.com> <4A1E9D8B.8020908@gmail.com> <1243542908.6645.104.camel@laptop> <4A20011E.7020900@nokia.com> <20090529155046.GH11363@kernel.dk> <4A20072B.7050807@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A20072B.7050807@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29 2009, Artem Bityutskiy wrote:
> Jens Axboe wrote:
>>> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
>>> index 2349e2c..d1ac967 100644
>>> --- a/fs/ubifs/super.c
>>> +++ b/fs/ubifs/super.c
>>> @@ -1929,6 +1929,9 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
>>> 	err  = bdi_init(&c->bdi);
>>> 	if (err)
>>> 		goto out_close;
>>> +	err = bdi_register(&c->bdi, NULL, "ubifs");
>>> +	if (err)
>>> +		goto out_close;
>>
>> Not quite right, you need to call bdi_destroy() if you have done the
>> init.
>
> Right, bdi_destroy() is already there for long time.
> I'm confused.
>
>> I committed this one this morning:
>>
>> http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=570a2fe1df85741988ad0ca22aa406744436e281
>
> Hmm, it is the same as my patch, but you do
> +       err = bdi_register(&c->bdi);
> while I do
> +	err = bdi_register(&c->bdi, NULL, "ubifs");

Oops, that's my bad. If you combine the two, we should have a working
patch :-)

>> But feel free to commit/submit to the ubifs tree directly, then it'll
>> disappear from my tree once it is merged.
>
> Yeah, I think it can go via my tree. I'd merge it at
> 2.6.31 window. This change does not depend on your
> work anyway.

Right, I'll just carry the fixup patches meanwhile as well, but wont
upstream them.

-- 
Jens Axboe


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762179AbZE2QEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762179AbZE2QEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 12:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbZE2QEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 12:04:39 -0400
Received: from smtp.nokia.com ([192.100.122.230]:31899 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbZE2QEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 12:04:38 -0400
Message-ID: <4A20072B.7050807@nokia.com>
Date: Fri, 29 May 2009 19:02:51 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Peter Zijlstra <peterz@infradead.org>,
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
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com> <4A1E9D0B.4090402@gmail.com> <4A1E9D8B.8020908@gmail.com> <1243542908.6645.104.camel@laptop> <4A20011E.7020900@nokia.com> <20090529155046.GH11363@kernel.dk>
In-Reply-To: <20090529155046.GH11363@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 May 2009 16:02:58.0253 (UTC) FILETIME=[EF4FFFD0:01C9E076]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
>> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
>> index 2349e2c..d1ac967 100644
>> --- a/fs/ubifs/super.c
>> +++ b/fs/ubifs/super.c
>> @@ -1929,6 +1929,9 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
>> 	err  = bdi_init(&c->bdi);
>> 	if (err)
>> 		goto out_close;
>> +	err = bdi_register(&c->bdi, NULL, "ubifs");
>> +	if (err)
>> +		goto out_close;
> 
> Not quite right, you need to call bdi_destroy() if you have done the
> init.

Right, bdi_destroy() is already there for long time.
I'm confused.

> I committed this one this morning:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=570a2fe1df85741988ad0ca22aa406744436e281

Hmm, it is the same as my patch, but you do
+       err = bdi_register(&c->bdi);
while I do
+	err = bdi_register(&c->bdi, NULL, "ubifs");

> But feel free to commit/submit to the ubifs tree directly, then it'll
> disappear from my tree once it is merged.

Yeah, I think it can go via my tree. I'd merge it at
2.6.31 window. This change does not depend on your
work anyway.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

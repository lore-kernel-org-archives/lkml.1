Return-Path: <linux-kernel-owner+w=401wt.eu-S1752052AbZFCHrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbZFCHrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 03:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbZFCHrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 03:47:22 -0400
Received: from smtp.nokia.com ([192.100.122.233]:51888 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008AbZFCHrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 03:47:21 -0400
Message-ID: <4A262A4D.5090509@nokia.com>
Date: Wed, 03 Jun 2009 10:46:21 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
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
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com> <4A1E9D0B.4090402@gmail.com> <4A1E9D8B.8020908@gmail.com> <1243542908.6645.104.camel@laptop> <4A20011E.7020900@nokia.com> <20090529155046.GH11363@kernel.dk> <4A20072B.7050807@nokia.com> <20090529170742.GI11363@kernel.dk> <4A2628A7.9080407@nokia.com> <20090603074417.GC11363@kernel.dk>
In-Reply-To: <20090603074417.GC11363@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Jun 2009 07:46:23.0578 (UTC) FILETIME=[645E23A0:01C9E41F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
>> Just to make sure I understood you correctly. I assume my original
>> patch is fine (because there is bdi_destroy()) and merge it to
>> ubifs tree.
> 
> It needs to be:
> 
>         err = bdi_register(&c->bdi, NULL, "ubifs");
>         if (err)
>                 goto out_bdi;
> 
> so you hit the bdi_destroy() for that failure, not goto out_close;
> Otherwise it was fine.

Ah, I see. Rather non-typical convention though. I expected
bdi_register() to clean-up stuff in case of failure. Isn't
it a better interface?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

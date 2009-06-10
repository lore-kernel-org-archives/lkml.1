Return-Path: <linux-kernel-owner+w=401wt.eu-S1761967AbZFJVF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761967AbZFJVF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757859AbZFJVFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:05:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46601 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758504AbZFJVFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:05:12 -0400
Date: Wed, 10 Jun 2009 23:05:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Karpov Denis.2 (EXT-Teleca/Helsinki)" <ext-denis.2.karpov@nokia.com>,
       "axboe@kernel.dk" <axboe@kernel.dk>,
       "hirofumi@mail.parknet.co.jp" <hirofumi@mail.parknet.co.jp>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
Message-ID: <20090610210507.GF1381@ucw.cz>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com> <20090603115611.6bbbaf55.akpm@linux-foundation.org> <4A276266.8000409@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A276266.8000409@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-04 08:57:58, Artem Bityutskiy wrote:
> Andrew Morton wrote:
>> hm, I'm uncertain on the desirability or otherwise of the overall feature.
>>
>> Are there users or distros or device manufacturers asking for this?  
>> Where did the requirement come from?
>>
>> What downstream application will handle the uevent messages?  Do you
>> have some userspace design/plan in mind?
>>
>> IOW, it would be useful if we were told more about all of this, rather
>> than just staring at a kernel patch!
>
> As the original idea came from me, while whole implementation
> and design was done by Denis, I'll comment on this.
>
> Our use-case is about hand-held devices. We are particularly
> working with large FAT volumes on MMC. Do not question please
> why it is FAT and not something else :-) Anyway, FAT is very
> unreliable, and often hits errors, in which case it simply
> switches to read-only mode, and usually prints something to
> the printk ring buffer.

So fsck the mmc card on card insertion...? fsck.vfat on flash is
pretty fast operation (as it onl needs to read directories +
FATs). Android 1.5 implements this.

...otherwise you will loose data on two files sharing clusters, will
never recover lost clusters, etc.

Perhaps it would be feasible  to permit read-only mount of unclean
VFAT, run fsck in background, and buffer any changes in memory until
fsck finishes?

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

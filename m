Return-Path: <linux-kernel-owner+w=401wt.eu-S934809AbYBOOWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934809AbYBOOWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 09:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934589AbYBOOV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 09:21:28 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:23600 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934578AbYBOOV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 09:21:27 -0500
Message-ID: <47B59FE5.9000506@msgid.tls.msk.ru>
Date: Fri, 15 Feb 2008 17:21:25 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] quota: Turn quotas off when remounting read-only
References: <20080207143721.GH6140@duck.suse.cz> <20080207103655.14ce8512.akpm@linux-foundation.org> <47AB5B9F.8090302@msgid.tls.msk.ru> <20080211123927.GF9622@duck.suse.cz> <Pine.LNX.4.64.0802151509010.30301@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0802151509010.30301@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Feb 11 2008 13:39, Jan Kara wrote:
>>> But...  I'm thinking about this scenario:
>>>
>>>  # mount /data
>>>  # quotaon /data
>>>  (some maintenance stuff to be planned)
>>>  # mount -o remount,ro /data
>>>  (do backup etc)
>>>  # mount -r remount,rw /data
>>>
>>> at this point, it's expected that quota on /data is enabled.
>>> After this patch, it's not anymore...
>>  Yes, it previously accidentally worked this way (for an year or so,
>> before that we refused to remount read-only). Hmm, but maybe we could
>> somehow tweak quotas to be turned on when remounting read-write again.
>> We have all the information we need at the time of remounting read-only
>> so we could store it and use it later when remounting read-write. I'll have
>> a look into that.
> 
> Maybe it is possible to leave quota on all times, so that the
> reporting quota ioctls continue to work even in ro mode?

Well, that'd be the best approach imho (plus check if all
ioctls which try to modify quotas fails with EROFS as
appropriate).

But the problem really is that it's unknown at this time
where it fails in the first place.  I can't reproduce my
hang "on demand" (mount-ro followed with umount when quotas
are turned on, with ext3fs - umount never finishes), yet
it has biten me for several times already.  So it must be
something rare, some small race maybe, which is difficult
to find...  Yet it finds itself at the most inappropriate
moment. ;)  I already learned to turn the quota off before
doing something with a filesystem, but sometimes I'm
forgetting this, and the result is always the same... ;)
Oh well.

/mjt

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbZBMGIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbZBMGIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 01:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbZBMGIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 01:08:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58462 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbZBMGII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 01:08:08 -0500
Message-ID: <49950E1E.8040307@redhat.com>
Date: Fri, 13 Feb 2009 00:07:26 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
CC: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@MIT.EDU>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
       Ric Wheeler <rwheeler@redhat.com>
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
References: <1232114101.13775.63.camel@sebastian.kern.oss.ntt.co.jp>	 <20090116163039.GE10617@duck.suse.cz>	 <1232185639.4831.18.camel@sebastian.kern.oss.ntt.co.jp>	 <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp>	 <20090119120349.GA10193@duck.suse.cz>	 <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp>	 <20090128095518.GA16554@duck.suse.cz>	 <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp>	 <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp>	 <499458C1.90105@redhat.com> <20090212212304.GA7935@duck.suse.cz>	 <499494E2.3060006@redhat.com> <1234489622.3795.49.camel@sebastian.kern.oss.ntt.co.jp>
In-Reply-To: <1234489622.3795.49.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fernando Luis Vázquez Cao wrote:
> On Thu, 2009-02-12 at 15:30 -0600, Eric Sandeen wrote:
>> Jan Kara wrote:
>>> On Thu 12-02-09 11:13:37, Eric Sandeen wrote:
>> ...
>>
>>>> Also that way if you have 8 partitions on a battery-backed blockdev, you
>>>> can tune it once, instead of needing to mount all 8 filesystems with the
>>>> new option.
>>>   Yes, but OTOH we should give sysadmin a possibility to enable / disable
>>> it on just some partitions. I don't see a reasonable use for that but people
>>> tend to do strange things ;) and here isn't probably a strong reason to not
>>> allow them.
>>>
>>> 								Honza
>> But nobody has asked for that, have they?  So why offer it up a this point?
>>
>> They could use LD_PRELOAD to make fsync a no-op if they really don't
>> care for it, I guess... though that's not easily per-fs either.
>>
>> But do we really want to go out of our way to enable people to
>> short-circuit data integrity paths and then file bugs when their files
>> go missing? :)
> 
> Well, it is just a matter of using safe defaults. IMHO, a scenario where
> the administrator wants to optimize writes to a certain partition and
> _explicitly_ clears MS_FLUSHONFSYNC on that superblock is not completely
> unreasonable.

One case is "this device is safe with a write cache and flush is not
necessary for data consistency" - that's the per-bdev setting.

The other case is "I don't really care and I just want to go faster" -
that's the per-mount setting.

I'd be much more likely to support the first case, as it's needed for
maximum performance w/o sacrificing correctness, when properly used.

The latter case is really only for cutting corners and giving people
more rope than they need to hang themselves.

>> (I guess the blockdev tunable is similarly dangerous, but it more
>> clearly meets the explicit need (writecache-safe devices))
> 
> If distributions use sane defaults and we document the mount option or
> bdev tunable properly I guess it might make sense to allow system
> administrators to shoot themselves in the foot.
> 
> (By the way, in this patch-set a patch for mount(8) is included.)

... one of the advantages of making it a bdev tunable is that you don't
have to mess with mount(8) :)

-Eric

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761024AbZBLVbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761024AbZBLVbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 16:31:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbZBLVaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 16:30:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37336 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbZBLVaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 16:30:55 -0500
Message-ID: <499494E2.3060006@redhat.com>
Date: Thu, 12 Feb 2009 15:30:10 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Theodore Tso <tytso@MIT.EDU>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
       Ric Wheeler <rwheeler@redhat.com>
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
References: <1232114101.13775.63.camel@sebastian.kern.oss.ntt.co.jp> <20090116163039.GE10617@duck.suse.cz> <1232185639.4831.18.camel@sebastian.kern.oss.ntt.co.jp> <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp> <20090119120349.GA10193@duck.suse.cz> <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp> <20090128095518.GA16554@duck.suse.cz> <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp> <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp> <499458C1.90105@redhat.com> <20090212212304.GA7935@duck.suse.cz>
In-Reply-To: <20090212212304.GA7935@duck.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
> On Thu 12-02-09 11:13:37, Eric Sandeen wrote:

...

>> Also that way if you have 8 partitions on a battery-backed blockdev, you
>> can tune it once, instead of needing to mount all 8 filesystems with the
>> new option.
>   Yes, but OTOH we should give sysadmin a possibility to enable / disable
> it on just some partitions. I don't see a reasonable use for that but people
> tend to do strange things ;) and here isn't probably a strong reason to not
> allow them.
> 
> 								Honza

But nobody has asked for that, have they?  So why offer it up a this point?

They could use LD_PRELOAD to make fsync a no-op if they really don't
care for it, I guess... though that's not easily per-fs either.

But do we really want to go out of our way to enable people to
short-circuit data integrity paths and then file bugs when their files
go missing? :)

(I guess the blockdev tunable is similarly dangerous, but it more
clearly meets the explicit need (writecache-safe devices))

-Eric

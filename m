Return-Path: <linux-kernel-owner+w=401wt.eu-S1750978AbXBKOww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978AbXBKOww (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 09:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbXBKOww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 09:52:52 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:50974 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbXBKOwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 09:52:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TzBbsazpilhFLCmpuhnvF5h9D+qAuyMMjuU0nFSUiAuQgzRmJa/4WUIH07Xim2k5gAnX6EEf55Jj+WeaL69KtJt9fcUvbWcJ9ncCsrBlwPBTj1IP/cuQtl1O8p6yy0+htM6y82+nWhIXPOTSkyq9sZJrQkQ2MYMitsJgPDnzjMQ=
Message-ID: <b637ec0b0702110652t67a4d9b5r74c85d69c3c7ca9b@mail.gmail.com>
Date: Sun, 11 Feb 2007 09:52:50 -0500
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Brad Campbell" <brad@wasp.net.au>, "Pierre Ossman" <drzeus-mmc@drzeus.cx>,
       "Alex Dubov" <oakad@yahoo.com>
Subject: Re: Recent and not-so problems with tifm_sd driver - one more
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45CEB1C9.5010103@wasp.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <113489.35158.qm@web36703.mail.mud.yahoo.com>
	 <45CDC22B.6040408@drzeus.cx> <45CEB1C9.5010103@wasp.net.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
I can see this problem too. I have CONFIG_SYSFS_DEPRECATED set.

It happens only with SD cards, with MMC everything is OK.

Fabio

On 2/11/07, Brad Campbell <brad@wasp.net.au> wrote:
> Pierre Ossman wrote:
> > Alex Dubov wrote:
> >> One more problem (you may already know about it) - I was contacted by somebody from the hald
> >> project and indeed I can confirm that on 2.6.20 kernel hald fails to take action on card
> >> insertion. I can't see anything in my code so this may be a general mmc problem.
> >> The problem is described here:
> >> http://lists.freedesktop.org/archives/hal/2007-January/006960.html
> >>
> >
> > Odd. This might be the whole sysfs restructuring thing causing problems. Can you
> > check if that user has CONFIG_SYSFS_DEPRECATED on?
>
> I've tested both with and without CONFIG_SYSFS_DEPRECATED on, both fail the same way.
> hald reports that the device has no parent and decides to ignore it.
>
> I've also tested both combinations against hal from ubuntu 6.06LTS and a more recent version
>
> brad@bklaptop2:~$ hald --version
> HAL package version: 0.5.8.1
>
> Again with and without CONFIG_SYSFS_DEPRECATED and all combinations fail.
> Hal appears to go looking for /sys/block/mmcblk0/mmcblk0p1/range
>
> When it can't find it, it then looks for the parent of that to check what would be
> /sys/block/mmcblk0/range, Complains it can't find a parent for /sys/block/mmcblk0/mmcblk0p1 and just
> proceeds to ignore the event.
>
> Brad
> --
> "Human beings, who are almost unique in having the ability
> to learn from the experience of others, are also remarkable
> for their apparent disinclination to do so." -- Douglas Adams
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

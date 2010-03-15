Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595Ab0COC0c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 22:26:32 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:61066 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759431Ab0COC0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 22:26:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=hg71WlaE5YWtoKkWOihSSJ3mGoNE/oqn71Sg8oJNZ2duUffpC6TJpQ1Az+I/snMkSo
         5xe2JuuiuYIC4jV7oIKk4mLgiPyZ5ZQ9Ilh6WAdBXd2B8UknoDr47TiLlgzcx0l+9giG
         Veq1exuLRlZ1/wT4zQnRBHIpY8aqh3hhkbmR0=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: ATA 4 KiB sector issues.
Date: Mon, 15 Mar 2010 03:26:22 +0100
User-Agent: KMail/1.8.2
Cc: Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
References: <4B947393.2050002@kernel.org> <1158166a1003100114j6ea329fbh84bfad65dcac90bf@mail.gmail.com> <4B9D8BB2.1010507@zytor.com>
In-Reply-To: <4B9D8BB2.1010507@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003150326.22262.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 March 2010 02:21, H. Peter Anvin wrote:
> On 03/10/2010 01:14 AM, Denys Vlasenko wrote:
> >
> > 63s/255h is more or less "standard" now.
> >
> > Alignment issues can be solved by picking a good multiple of
> > _heads_ or _cylinders_:
> >
> > For first partition, pick the start at 8th head:
> >
> > cyl 0 head 1 sector 1: LBA sector 63) - bad
> > cyl 0 head 8 sector 1: LBA sector 8*63) - good (4k aligned)
> >
> > For any other partition, pick start cylinder which is a multiple of 8:
> >
> > cyl 8*x head 0 sector 1: LBA sector 8*x*255*63 - good (4k aligned)
> >
> > This will actually work well for *any* geometry, not only for 63s/255h.
> 
> Yes, but it does squat for a flash disk that wants, say, 256K alignment.

4K makes sense. 256K not so much.

256K alignment is hard to swallow for a lot of reasons anyway.
Unless the filesystem packs small files into blocks a-la reiserfs,
256K block filesystems will be very inefficient for a typical
storage scenarios.

It looks like flash storage manufacturers just have to bite
the bullet and develop smarter algorithms that combine wear
leveling, block remapping and such and make their internal
preference for huge continuous aligned writes nearly invisible
from the outside - just like hard disks which do not expose
their zoned recording, variable sector counts etc.

Such algorithms aren't trivial, but they are possible.
Whoever will incorporate them in their products,
delivers a significantly better user experience.

I just played with ubuntu installation on an usb stick.
Yes, it works. Soft of. Write performance is abysmal.
I would pay x2 or x3 for the same sized stick if it
would perform better.

-- 
vda

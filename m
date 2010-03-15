Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935252Ab0COBWw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 21:22:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35328 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935078Ab0COBWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 21:22:50 -0400
Message-ID: <4B9D8BB2.1010507@zytor.com>
Date: Sun, 14 Mar 2010 18:21:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <201003100046.24695.arnd@arndb.de> <1158166a1003100114j6ea329fbh84bfad65dcac90bf@mail.gmail.com>
In-Reply-To: <1158166a1003100114j6ea329fbh84bfad65dcac90bf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2010 01:14 AM, Denys Vlasenko wrote:
>
> 63s/255h is more or less "standard" now.
>
> Alignment issues can be solved by picking a good multiple of
> _heads_ or _cylinders_:
>
> For first partition, pick the start at 8th head:
>
> cyl 0 head 1 sector 1: LBA sector 63) - bad
> cyl 0 head 8 sector 1: LBA sector 8*63) - good (4k aligned)
>
> For any other partition, pick start cylinder which is a multiple of 8:
>
> cyl 8*x head 0 sector 1: LBA sector 8*x*255*63 - good (4k aligned)
>
> This will actually work well for *any* geometry, not only for 63s/255h.

Yes, but it does squat for a flash disk that wants, say, 256K alignment.

	-hpa

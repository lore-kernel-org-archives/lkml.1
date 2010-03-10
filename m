Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab0CJJOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 04:14:14 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:60462 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab0CJJOJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 04:14:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tfu+nvP2+CcmUmyZOkUHTheBBs9mWzYQUC9dy/NfrC+ptizKge4xt+36rq+/Vgvjiq
         ipBWu4pebXgsZUkkoPPFftaXhrYzNsyn7NMhHefgAhndGuwNILoGLlVbbe70a2dp+37D
         Aiv1JCfledeebsVaVulAOySFR+aPvMtZuykUI=
MIME-Version: 1.0
In-Reply-To: <201003100046.24695.arnd@arndb.de>
References: <4B947393.2050002@kernel.org> <201003100046.24695.arnd@arndb.de>
Date: Wed, 10 Mar 2010 10:14:07 +0100
Message-ID: <1158166a1003100114j6ea329fbh84bfad65dcac90bf@mail.gmail.com>
Subject: Re: ATA 4 KiB sector issues.
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 12:46 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 08 March 2010 04:48:35 Tejun Heo wrote:
>> Unfortunately, while Windows can assume that newer releases won't
>> share the hard drive with older releases including Windows XP, Linux
>> distros can't do that.  There will be many installations where a
>> modern Linux distros share a hard drive with older releases of
>> Windows.  At this point, I can't see a silver bullet solution.
>>
>> Partitioners maybe should only align partitions which will be used by
>> Linux and default to the traditional layout for others while allowing
>> explicit override.  I think Windows XP wouldn't have problem with
>> differently aligned partitions as long as it doesn't actually use them
>> but haven't tested it.
>
> Any idea if XP can cope with partition tables that use a 32-sector, 128-head
> geometry rather than the default 63-sector, 255-head one? That seems to
> be what some flash memory cards are using and it would make any cylinder
> aligned partition also 4096-byte aligned, at the cost of moving the
> 1024-cylinder boundary from 7.88 GiB to 2 GiB.
>
> Do we know of anything that requires 63s/255h?

63s/255h is more or less "standard" now.

Alignment issues can be solved by picking a good multiple of
_heads_ or _cylinders_:

For first partition, pick the start at 8th head:

cyl 0 head 1 sector 1: LBA sector 63) - bad
cyl 0 head 8 sector 1: LBA sector 8*63) - good (4k aligned)

For any other partition, pick start cylinder which is a multiple of 8:

cyl 8*x head 0 sector 1: LBA sector 8*x*255*63 - good (4k aligned)

This will actually work well for *any* geometry, not only for 63s/255h.
-- 
vda

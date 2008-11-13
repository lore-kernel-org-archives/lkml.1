Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbYKMOvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbYKMOvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbYKMOvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:51:06 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:15594 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbYKMOvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:51:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WP7lmn24WMY/Haa+r8c02szA65f0+YikVfL02Rd9/98QsUrbrhtNPxl/jQVvbFYCxp
         yvkAi/Nhc36Sin32wrZiXJY6MMqhCRn9ct+HVgHhRYnQqJ6/6vzhTYWxWdtvKvbE1j02
         H73xoE4qhoAf9hrBTQhZBFeHRVKuEfij0mchI=
Message-ID: <8bd0f97a0811130651k11c52a53j91c80cf196e9f66a@mail.gmail.com>
Date: Thu, 13 Nov 2008 09:51:01 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Atsushi Nemoto" <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] mtd: unify mtd partition/device registration
Cc: vapier@gentoo.org, linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081113.232823.125897716.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226533133-7405-1-git-send-email-vapier@gentoo.org>
	 <20081113.224350.18312549.anemo@mba.ocn.ne.jp>
	 <20081113.232823.125897716.anemo@mba.ocn.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 09:28, Atsushi Nemoto wrote:
> On Thu, 13 Nov 2008 22:43:50 +0900 (JST), Atsushi Nemoto wrote:
>> On Wed, 12 Nov 2008 18:38:53 -0500, Mike Frysinger wrote:
>> > Rather than having every map/mtd driver doing the same sequence of
>> > registering partitions and/or devices, implement common parse_mtd().
>> >
>> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> > ---
>> >  drivers/mtd/mtdcore.c   |   37 +++++++++++++++++++++++++++++++++++++
>> >  include/linux/mtd/mtd.h |    3 +++
>> >  2 files changed, 40 insertions(+), 0 deletions(-)
>>
>> I like this idea.
>
> Some drivers call both add_mtd_device() and add_mtd_partitions().  The
> mtd_device is used to access whole flash area (like /dev/hda).  How do
> you think of these usage patterns?
>
> maps/edb7312.c
> maps/mbx860.c
> maps/plat-ram.c
> nand/cafe_nand.c
> nand/diskonchip.c
> nand/ndfc.c
>
> Automatic fallback to mtd_device in parse_mtd() is convenient but
> somewhat unflexible...

we could just have it do it all the time.  i dont see a problem with
exposing the entire block device the whole time ?  i know for the
driver or two of mine, i'm fine with it.

...
       ret = parse_mtd_partitions(mtd, probe_types, &parts, 0);
       if (ret > 0) {
               ret = add_mtd_partitions(mtd, parts, ret);
               kfree(parts);
       } else if (nr_parts)
               ret = add_mtd_partitions(mtd, parts, nr_parts);
       if (ret)
               return ret;
#endif

       return add_mtd_device(mtd);
-mike

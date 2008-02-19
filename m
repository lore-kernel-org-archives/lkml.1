Return-Path: <linux-kernel-owner+w=401wt.eu-S1757738AbYBSITf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738AbYBSITf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 03:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbYBSIT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 03:19:27 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:42405 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbYBSIT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 03:19:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=R01GW1UqzvMmOltj0tRnJgqXk4lm/6CbSPbG+nHadkx2K3xGz1xjUYrjJpZXhQ/MBWKiYK9fD47VWHncf27kYmrAyDp0wJkJE6jMjTcdQSgSaIuHBhPU6D4Mp4fL1kw7tN2/TOFx6Zy0d8lprpzbiN3RZf8Liwtt18nFZiS2EHs=
Message-ID: <3ae72650802190019u76857e61n4ee543d33fd3c5fc@mail.gmail.com>
Date: Tue, 19 Feb 2008 09:19:25 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.25-rc1-sha1: WARNING: at lib/kref.c:43 kref_get+0x20/0x30()
Cc: "Alexey Dobriyan" <adobriyan@sw.ru>, linux-kernel@vger.kernel.org,
       "Greg KH" <greg@kroah.com>
In-Reply-To: <20080218045925.40fc5ddb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080215110853.GH6110@localhost.sw.ru>
	 <20080218045925.40fc5ddb.akpm@linux-foundation.org>
X-Google-Sender-Auth: 181641a0cb72c261
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 18, 2008 1:59 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 15 Feb 2008 14:08:53 +0300 Alexey Dobriyan <adobriyan@sw.ru> wrote:
>
> > Booting without SYSFS fills dmesg like this
>
> Does the system normally boot without sysfs?  Surprised.
>
>
> > ------------[ cut here ]------------
> > WARNING: at lib/kref.c:43 kref_get+0x20/0x30()
> > Modules linked in: loop(+)
> > Pid: 994, comm: modprobe Tainted: G   M     2.6.25-rc1 #6
> >
> > Call Trace:
> >  [<ffffffff802317f4>] warn_on_slowpath+0x64/0x90
> >  [<ffffffff8028db08>] init_object+0x88/0xa0
> >  [<ffffffff8028f55e>] __slab_alloc+0xbe/0x550
> >  [<ffffffff8031aa28>] kvasprintf+0x58/0x90
> >  [<ffffffff8031874c>] vsnprintf+0x33c/0x6e0
> >  [<ffffffff8031aa41>] kvasprintf+0x71/0x90
> >  [<ffffffff8022c597>] hrtick_set+0x77/0x140
> >  [<ffffffff80314860>] kref_get+0x20/0x30
> >  [<ffffffff80313932>] kobject_get+0x12/0x20
> >  [<ffffffff803139f9>] kobject_add_internal+0x49/0xf0
> >  [<ffffffff80313bb3>] kobject_add_varg+0x73/0x80
> >  [<ffffffff80313fa4>] kobject_add+0x54/0x80
> >  [<ffffffff8028ec53>] check_object+0x103/0x230
> >  [<ffffffff8028db08>] init_object+0x88/0xa0
> >  [<ffffffff80313744>] kobject_create+0x14/0x40
> >  [<ffffffff8028fbd3>] kmem_cache_alloc+0xd3/0xe0
> >  [<ffffffff803136b4>] kobject_init+0x34/0xb0
> >  [<ffffffff8031375b>] kobject_create+0x2b/0x40
> >  [<ffffffff8031400c>] kobject_create_and_add+0x3c/0x80
> >  [<ffffffff8025e137>] load_module+0x1847/0x1970
> >  [<ffffffff80288800>] alloc_pages_current+0x0/0x90
> >  [<ffffffff8025e2c2>] sys_init_module+0x62/0x1a0
> >
>
> Is this a regression?

Alexey,
do you always see these messages with every modprobe of a module?

Can you enable CONFIG_DEBUG_KOBJECT=y? It might give a hint where we
miss to initialization of a kobject when sysfs is not compiled in.

Thanks,
Kay

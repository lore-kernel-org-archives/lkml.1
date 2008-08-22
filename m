Return-Path: <linux-kernel-owner+w=401wt.eu-S1759853AbYHVHCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759853AbYHVHCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 03:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbYHVHCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 03:02:34 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:22863 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbYHVHCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 03:02:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=lSNCqyLh8miycSHHLiE6SlzdfV+8KsSArOF+sWylugbEDod/eRHYtzT+RPwhRQGr99
         1MO9/aawr8BJls6L9NaWks5KFCgLjHkrD6XRL4ULY+gwu95ltIuTKw7ULnKRmWQI4/qS
         lvJ9+axxzu/7HK/9IA4iSGlnAysHccqfzvo0o=
Message-ID: <84144f020808220002g2294aed1r66d38d84b28961a2@mail.gmail.com>
Date: Fri, 22 Aug 2008 10:02:31 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: latest -git: suspend: unable to handle kernel paging request (was Re: no_console_suspend doesn't work?)
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <200808220010.37733.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808211028w7889587fke523ff244339e7c5@mail.gmail.com>
	 <19f34abd0808211308t2ee63a37kc204a5849231af45@mail.gmail.com>
	 <84144f020808211421l643eef28p4ea2754b3f0c786a@mail.gmail.com>
	 <200808220010.37733.rjw@sisk.pl>
X-Google-Sender-Auth: 42d404a6f8d9ae4c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Fri, Aug 22, 2008 at 1:10 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> I don't know the suspend code at all but the bogus pointer coming from
>> hibernation_snapshot() seems suspicious.
>
> Which one?

This trace here (which has IDE too):

> > Call Trace:
> >  [<c0683402>] ? wait_for_completion+0x12/0x20
>
> Here the block layer is passing a pointer to a non-slab page to
> kmem_cache_free(). Assuming we can rely on the stack trace, of
> course...
>
> >  [<c018976e>] ? mempool_free_slab+0xe/0x10
> >  [<c036a7b0>] ? blk_end_sync_rq+0x0/0x30
> >  [<c01b3c9c>] ? kmem_cache_free+0x5c/0x200
> >  [<c018976e>] ? mempool_free_slab+0xe/0x10
> >  [<c018979c>] ? mempool_free+0x2c/0x90
> >  [<c0367252>] ? __blk_put_request+0x62/0x90
> >  [<c036764c>] ? blk_put_request+0x2c/0x50
> >  [<c0470732>] ? generic_ide_resume+0xa2/0xf0     <-- IDE
> >  [<c03f767e>] ? device_resume+0x32e/0x380
> >  [<c01687d1>] ? hibernation_snapshot+0xa1/0x220 <--- Suspend
> >  [<c013b57b>] ? printk+0x1b/0x20
> >  [<c0168a30>] ? hibernate+0xe0/0x180
> >  [<c01674e0>] ? state_store+0x0/0xd0
> >  [<c016759f>] ? state_store+0xbf/0xd0
> >  [<c01674e0>] ? state_store+0x0/0xd0
> >  [<c03749d4>] ? kobj_attr_store+0x24/0x30
> >  [<c01f8ef2>] ? sysfs_write_file+0xa2/0x100
> >  [<c01ba946>] ? vfs_write+0x96/0x130
> >  [<c01f8e50>] ? sysfs_write_file+0x0/0x100
> >  [<c01bae8d>] ? sys_write+0x3d/0x70
> >  [<c0104f3b>] ? sysenter_do_call+0x12/0x3f

But like I said, the stack traces seem more unreliable than usual so I
could be totally wrong here.

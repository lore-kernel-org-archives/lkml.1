Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbYJQXTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbYJQXTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 19:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbYJQXTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 19:19:16 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:47062 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbYJQXTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 19:19:15 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 17 Oct 2008 16:19:13 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Alexander Beregalov <a.beregalov@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
Subject: Re: 2.6.27-05178-g2e532d6: list_add corruption
In-Reply-To: <a4423d670810171220t4d5602fekcb66e18758149925@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0810171617490.21410@alien.or.mcafeemobile.com>
References: <a4423d670810171220t4d5602fekcb66e18758149925@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008, Alexander Beregalov wrote:

> I am afraid I do not know how to reproduce this.
> 
> WARNING: at lib/list_debug.c:30 __list_add+0x44/0x5c()
> list_add corruption. prev->next should be next (f6638448), but was
> f26f078c. (prev=f26f078c).
> Modules linked in: w83627hf hwmon_vid i2c_nforce2
> Pid: 1933, comm: rtorrent Not tainted 2.6.27-05178-g2e532d6 #6
> Call Trace:
>  [<c011de4b>] warn_slowpath+0x4b/0x69
>  [<c0137a03>] ? trace_hardirqs_off+0xb/0xd
>  [<c01070ab>] ? native_sched_clock+0x76/0x88
>  [<c0138cc5>] ? trace_hardirqs_on+0xb/0xd
>  [<c0138c93>] ? trace_hardirqs_on_caller+0xe6/0x10d
>  [<c031aa43>] ? release_sock+0xac/0xb4
>  [<c0138cc5>] ? trace_hardirqs_on+0xb/0xd
>  [<c0139d4e>] ? __lock_acquire+0xaeb/0xafa
>  [<c0139d4e>] ? __lock_acquire+0xaeb/0xafa
>  [<c0137a39>] ? put_lock_stats+0xd/0x21
>  [<c026a404>] __list_add+0x44/0x5c
>  [<c0186be0>] ep_poll_callback+0x5b/0xb4

This is very likely to be caused by a patch that went in a few days ago. 
Already posted a fix to Andrew.



- Davide



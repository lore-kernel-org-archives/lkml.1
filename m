Return-Path: <linux-kernel-owner+w=401wt.eu-S1760651AbXKNRno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760651AbXKNRno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 12:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbXKNRng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 12:43:36 -0500
Received: from twin.jikos.cz ([213.151.79.26]:52501 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269AbXKNRnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 12:43:35 -0500
Date: Wed, 14 Nov 2007 18:38:28 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: 2.6.24-rc2-mm1
In-Reply-To: <Pine.LNX.4.64.0711141758570.15844@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0711141837420.15844@twin.jikos.cz>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0711141728290.15844@twin.jikos.cz>
 <20071114083906.178232cb.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0711141740110.15844@twin.jikos.cz>
 <Pine.LNX.4.64.0711141758570.15844@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007, Jiri Kosina wrote:

> Well not that fine, I still see (which is the same backtrace that caused 
> the lockup with plain -rc2-mm1, but doesn't make the machine hang):
> floppy0: Floppy io-port 0x03f2 in use
> WARNING: at lib/kref.c:33 kref_get()
> Call Trace:
>  [<ffffffff8035bd43>] kobject_add+0x9b/0x197
>  [<ffffffff8035c6e1>] kref_get+0x2f/0x36
>  [<ffffffff8035b82f>] kobject_get+0x12/0x17
>  [<ffffffff8035bd55>] kobject_add+0xad/0x197
>  [<ffffffff802c9a36>] register_disk+0x48/0x205
>  [<ffffffff80355cf3>] add_disk+0x34/0x3d
>  [<ffffffff8083cd99>] rd_init+0x172/0x1e1
>  [<ffffffff8082063a>] kernel_init+0x175/0x2e6
>  [<ffffffff8025193c>] trace_hardirqs_on+0x115/0x139
>  [<ffffffff80598769>] trace_hardirqs_on_thunk+0x35/0x3a
>  [<ffffffff8025193c>] trace_hardirqs_on+0x115/0x139
>  [<ffffffff8020c628>] child_rip+0xa/0x12
>  [<ffffffff8020bd3f>] restore_args+0x0/0x30
>  [<ffffffff808204c5>] kernel_init+0x0/0x2e6
>  [<ffffffff8020c61e>] child_rip+0x0/0x12

And this goes away when 
gregkh-driver-remove-struct-kobj_type-from-struct-kset is reverted.

-- 
Jiri Kosina

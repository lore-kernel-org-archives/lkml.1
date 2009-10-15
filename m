Return-Path: <linux-kernel-owner+w=401wt.eu-S1761996AbZJOKkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761996AbZJOKkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 06:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757324AbZJOKkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 06:40:14 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:62159 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756594AbZJOKkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 06:40:13 -0400
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: kmemleak errors
References: <804dabb00910142027r7f771ee4n2855fef7dcffbacc@mail.gmail.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 15 Oct 2009 11:39:30 +0100
In-Reply-To: <804dabb00910142027r7f771ee4n2855fef7dcffbacc@mail.gmail.com> (Peter Teoh's message of "Thu\, 15 Oct 2009 11\:27\:34 +0800")
Message-ID: <tnxfx9l9c0t.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Oct 2009 10:39:35.0101 (UTC) FILETIME=[C98D36D0:01CA4D83]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Teoh <htmldeveloper@gmail.com> wrote:
> cat /sys/kernel/debug/kmemleak gave:
>
> unreferenced object 0xffff8800bd864000 (size 40):
>   comm "swapper", pid 0, jiffies 4294937296
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 70 40 86 bd 00 88 ff ff  ........p@......
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff81ef55b6>] kmemleak_alloc+0x73/0xd8
>     [<ffffffff81154d66>] kmem_cache_alloc+0xf7/0x15a
>     [<ffffffff82b2b88a>] debug_objects_mem_init+0x71/0x234
>     [<ffffffff82afef26>] start_kernel+0x356/0x414
>     [<ffffffff82afe2a9>] x86_64_start_reservations+0xb9/0xd4
>     [<ffffffff82afe3b2>] x86_64_start_kernel+0xee/0x109
>     [<ffffffffffffffff>] 0xffffffffffffffff

If run

  echo scan > /sys/kernel/debug/kmemleak

a few times, do they disappear? I think the debug_objects reports are
false positives but couldn't figure why kmemleak cannot track
them. I'll look again at them and maybe add an annotation
(kmemleak_not_leak).

-- 
Catalin

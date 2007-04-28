Return-Path: <linux-kernel-owner+w=401wt.eu-S965747AbXD1K4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965747AbXD1K4l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 06:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965796AbXD1K4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 06:56:41 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:56258 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965747AbXD1K4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 06:56:39 -0400
Date: Sat, 28 Apr 2007 12:53:51 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Roland Dreier <rdreier@cisco.com>, Dave Jones <davej@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
In-Reply-To: <20070428011625.0f048426.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0704281240390.506@yvahk01.tjqt.qr>
References: <20070423141123.GA21174@skybase> <20070423104534.51bac974.akpm@linux-foundation.org>
 <20070425112133.4ae86399.randy.dunlap@oracle.com>
 <20070425143011.57247c1d.akpm@linux-foundation.org>
 <20070425172447.1576c399.akpm@linux-foundation.org> <20070426003911.GA19383@redhat.com>
 <4630109F.6090002@oracle.com> <20070425200207.77a2721a.akpm@linux-foundation.org>
 <20070428030805.GA13331@redhat.com> <20070427221803.2a117c23.akpm@linux-foundation.org>
 <adak5vxm459.fsf@cisco.com> <Pine.LNX.4.61.0704280956190.506@yvahk01.tjqt.qr>
 <20070428011625.0f048426.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 28 2007 01:16, Andrew Morton wrote:
>On Sat, 28 Apr 2007 10:01:00 +0200 (MEST) Jan Engelhardt wrote:
>
>> And since when is uint32_t wrong? What makes u32 or __u32 better?
>
>There's not much to be said in favour of u32, really.  Except it's
>shorter and I can never remember where the underscore goes in uint_32t.

The underscore always goes before the final t (short for type I assume).
The typedefs in the kernel do the same... kmem_cache_t (now replaced,
though) as an example.

>If kernel used u_int32_t globally then the world would probably be a
>better place.  But using just the one name has its advantages from a
>consistency POV.

#undef u32
#undef u_int32_t

>box:/usr/src/linux-2.6.21> grep -r '[   \(]u32' . | wc -l
>39599
>box:/usr/src/linux-2.6.21> grep -r '[   \(]uint32_t' . | wc -l 
>5132

Once again, \b comes to the rescue! :)
[And it also works with u32 at SOL and EOLs, and -o counts the number of
occurrences, not the number of lines]

grep -or '\b__uX\b' . | wc -l

.----..-------.------.---------.----------..------.------.--------.
|    ||    uX | __uX | uintX_t | u_intX_t ||   sX | __sX | intX_t |
>====**=======*======*=========*==========**======*======*========<
|  8 || 28004 | 6159 |    3883 |      422 ||  416 |   65 |     75 |
| 16 || 13734 | 3557 |    2613 |      426 ||  393 |  128 |     19 |
| 32 || 42971 | 6656 |    5416 |      879 || 1442 |  363 |    428 |
| 64 || 11219 | 1613 |     811 |       59 || 1061 |   81 |    111 |
`----^^-------^------^---------^----------^^------^------^--------'

The tendency towards __uX and uX is probably because these have been
existent since decades, even before stdint.h and uintX_t got introduced.
Which btw, is another point. Userspace programs that need to include
files from /usr/include/linux sometimes have a hard time compiling
because they want u8, which is defined (or not!) somewhere in
/usr/include/asm. Maybe it is not a problem anymore today, but I had
had it often enough to call it a problem. This is where uintX_t could come
a little more handy, because userspace has a higher chance of already
knowing it through stdint.h or some compiler foo.


Jan
-- 

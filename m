Return-Path: <linux-kernel-owner+w=401wt.eu-S1767272AbXCINH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767272AbXCINH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 08:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767273AbXCINHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 08:07:35 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49820 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767271AbXCINHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 08:07:31 -0500
Date: Fri, 9 Mar 2007 14:10:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: "Benjamin LaHaise" <bcrl@kvack.org>, "Eric Dumazet" <dada1@cosmosbay.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: sys_write() racy for multi-threaded append?
Message-ID: <20070309141033.553d94fa@lxorguk.ukuu.org.uk>
In-Reply-To: <f2b55d220703090419w755d42d0mea4f220e3caaa59a@mail.gmail.com>
References: <f2b55d220703081508r3d8d033cu99f53104943d16cb@mail.gmail.com>
	<45F09F9C.4030801@cosmosbay.com>
	<f2b55d220703081557k8101e68g1a3556e42f68416@mail.gmail.com>
	<45F0A71C.2000800@cosmosbay.com>
	<f2b55d220703081645vc78905cj56afbc58ad2113d8@mail.gmail.com>
	<20070309013405.GI6209@kvack.org>
	<f2b55d220703090419w755d42d0mea4f220e3caaa59a@mail.gmail.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 1003.1 unless O_NONBLOCK is set.  (Not that f_pos is interesting on a
> pipe except as a "bytes sent" indicator  -- and in the multi-threaded

f_pos is undefined on a FIFO or similar object.

> As to what a "sane app" has to do: it's just not that unusual to write
> application code that treats a short read/write as a catastrophic
> error, especially when the fd is of a type that is known never to
> produce a short read/write unless something is drastically wrong.  For

If you are working in a strictly POSIX environment then a signal can
interrupt almost any I/O as a short write even disk I/O. In the sane
world the file I/O cases don't do this.

> as long as the fd doesn't get screwed up.  There is no reason for the
> generic sys_read code to leave a race open in which the same frame is
> read by both threads and a hardware buffer overrun results later.

Audio devices are not seekable anyway.

> concurrent reads and writes to arbitrary fd types.  I'm proposing that
> it not do something blatantly stupid and easily avoided in generic
> code that makes it impossible for any fd type to guarantee that, after
> 10 successful pipelined 100-byte reads or writes, f_pos will have
> advanced by 1000.

You might want to read up on the Unix design philosophy. Things like
record based I/O are user space to avoid kernel complexity and also so
that the overhead of these things is paid only by those who need them
(its kind of RISC for OS design).

Alan

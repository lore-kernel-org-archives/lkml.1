Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbYL0UqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbYL0UqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 15:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYL0UqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 15:46:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60292 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbYL0UqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 15:46:06 -0500
Message-ID: <495693E5.3060604@zytor.com>
Date: Sat, 27 Dec 2008 12:45:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
References: <1230360604-6711-1-git-send-email-vapier@gentoo.org> <200812271421.10087.vapier@gentoo.org> <495680A7.2010900@zytor.com> <200812271505.46872.vapier@gentoo.org>
In-Reply-To: <200812271505.46872.vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Saturday 27 December 2008 14:23:19 H. Peter Anvin wrote:
>> Mike Frysinger wrote:
>>> {su}{8,16,32,64} doesnt matter too much to me vs {u,}int_t{8,16,32,64}_t.
>>>  as long as people stop using __{su}{8,16,32,64}.  using the latter
>>> though does mean headers will more likely be "just usable" w/out needing
>>> linux/types.h include.  but then people would be forced to include
>>> stdint.h or similar before a linux header ... and that sucks.
>> That is a total non-starter.  This would mean that the C library itself
>> cannot use these headers without exporting additional symbols into the
>> namespace, *WHICH IT IS NOT ALLOWED TO DO*.
> 
> which is already happening today you mean.  grep the kernel headers and you'll 
> see a ton of [u]intXX_t hits.

Now, keep in mind this is only true for headers exported to userspace.
But this is correct - which is the base of this conversation (Sam
suggesting that they should be warned about, and I suggested
auto-converting them.)

> this logic though means that the kernel should not be defining any structures 
> that the C library is defining (such as asm-generic/fcntl.h).  such structs 
> should get renamed the same way as __[us]XX types

This is also correct, at least for exported headers.  For
kernel-internal headers, it doesn't matter.  Unfortunately we do have at
least several cases of exported interfaces with globally visible names.

There is one other exception of note, which is a header file which can
only be included by the userspace *application*, using a nonportable
top-level include (either directly <linux/*> or indirectly via <sys/*>).
 In those cases we can be looser about at least structure names.  This
is common for ioctl structures.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754383AbYGGIDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbYGGIDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 04:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYGGIDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 04:03:06 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:46871 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbYGGIDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 04:03:05 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH] loop: prevent get_user pages call from kernel thread(v2)
References: <1215278340-3509-1-git-send-email-dmonakhov@openvz.org>
	<87tzf3qlz7.fsf@basil.nowhere.org>
From: Dmitri Monakhov <dmonakhov@openvz.org>
Date: Mon, 07 Jul 2008 12:02:20 +0400
In-Reply-To: <87tzf3qlz7.fsf@basil.nowhere.org> (Andi Kleen's message of "Sun\, 06 Jul 2008 13\:40\:44 +0200")
Message-ID: <m3zlouceb7.fsf@dmon-lap.sw.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Dmitri Monakhov <dmonakhov@openvz.org> writes:
>
>> Yes... everybody know that it is bad to write from kernel thread, and it is
>> madness to do it with O_DIRECT. But occasionly file with O_DIRECT flag
>> may be passed to loop device via LOOP_SET_FD. So if file-system has't
>> address_space ops, or simply hide it like GFS, it is possible to kill kernel
>> via two lines program. In fact we can't effectively guard kernel space by
>> deny O_DIRECT in loop's code, because user space can set it via
>> fcntl(,F_SETFL,). Let's simply add sanity check mm related logic.	
>
> Wouldn't it be better if loop simply dup()ed the file descriptor
> and then checked the flag?  Presumably other fd flags could
> do bad things inside loop too.
Off course this can't work because both fd refer to the same struct file.
man fcntl:
 File status flags
       Each open file description has certain associated status flags, ini-
       tialized  by  open(2) and possibly modified by fcntl(2).  Duplicated
       file descriptors (made with dup(2), fcntl(F_DUPFD),  fork(2),  etc.)
       refer  to  the  same  open file description, and thus share the same
       file status flags.
>
> -Andi

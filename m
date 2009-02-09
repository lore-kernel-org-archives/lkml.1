Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbZBILbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbZBILbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 06:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbZBILbC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 06:31:02 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53740 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbZBILbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 06:31:00 -0500
Message-ID: <499013CC.2060808@cn.fujitsu.com>
Date: Mon, 09 Feb 2009 19:30:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
       containers@lists.osdl.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [cgroup or VFS ?]  WARNING: at fs/namespace.c:636	mntput_no_expire+0xac/0xf2()
References: <49617D35.4040805@cn.fujitsu.com> <20090209004046.3ce1dde0.akpm@linux-foundation.org> <20090209093414.GU28946@ZenIV.linux.org.uk>
In-Reply-To: <20090209093414.GU28946@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Mon, Feb 09, 2009 at 12:40:46AM -0800, Andrew Morton wrote:
>>> Thread 1:
>>>   for ((; ;))
>>>   {
>>>       mount -t cgroup -o cpuset xxx /mnt > /dev/null 2>&1
>>>       mkdir /mnt/0 > /dev/null 2>&1
>>>       rmdir /mnt/0 > /dev/null 2>&1
>>>       umount /mnt > /dev/null 2>&1
>>>   }
>>>
>>> Thread 2:
>>>   {
>>>       mount -t cpuset xxx /mnt > /dev/null 2>&1
>>>       umount /mnt > /dev/null 2>&1
>>>   }
> 
> How cute...  Same mountpoint in both, so these mount(2) will sometimes
> fail (cgroup picks the same sb on the same options, AFAICS) and fail
> silently due to these redirects...
> 
> That's a lovely way to stress-test a large part of ro-bind stuff *and*
> umount()-related code.  Could you do C equivalent of the above (just
> the same syscalls in loop, nothing fancier) and do time-stamped strace?
> 

Sure, I'll write a C version and try to reproduce the warning.



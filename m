Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab0CHWc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 17:32:26 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:41603 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914Ab0CHWcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 17:32:21 -0500
Message-ID: <4B957AF3.6040801@msgid.tls.msk.ru>
Date: Tue, 09 Mar 2010 01:32:19 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-aio@kvack.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: aio: compat_ioctl issue?
References: <4B956E5B.9020302@msgid.tls.msk.ru>	<x497hpm8p69.fsf@segfault.boston.devel.redhat.com>	<4B957122.4060007@msgid.tls.msk.ru> <x49mxyi78ob.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49mxyi78ob.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer wrote:
[]
>>>> I just come across a situation (next in a long row :)
>>>> when on x86, 32bit userspace does not work with 64bit
>>>> kernel.  This time this is about aio requests.
> [snip]

> Well, I'm not experiencing such problems.  I can run a 32bit aio
> application on a 64bit kernel just fine with 2.6.31, 2.6.32 and
> 2.6.34-rc1.

Interesting.  I mentioned that I _think_ I used Oracle 32bit with
AIO on 64bit kernel, but I'm not sure.

> Could you maybe print out the values that are passed to io_getevents?

They were in my first email, here it goes again:

io_submit: lio_opcode=7 reqprio=0 iov=0x9cd7018{0xf5599000,4096}, niov=1, offset=0
io_getevents: expected 4096 got -22 (EINVAL)

This is what gets passed to libaio -- strace here
does not decode the arguments unfortunately.

The file in question is raw partition open with O_DIRECT,
if that makes any difference.

64bit binary uses very similar arguments except that
addresses are different.

My *guess* is that it handles read/write correctly but
does not properly handle preadv/pwritev (opcode=7 is
IO_CMD_PREADV as far as I can see).  That'll explain
my "testcase" with Oracle which does not use preadv.

Thanks!

/mjt

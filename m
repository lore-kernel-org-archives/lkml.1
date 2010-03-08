Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab0CHVil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:38:41 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:51425 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532Ab0CHVii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:38:38 -0500
Message-ID: <4B956E5B.9020302@msgid.tls.msk.ru>
Date: Tue, 09 Mar 2010 00:38:35 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: linux-aio@kvack.org
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: aio: compat_ioctl issue?
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I just come across a situation (next in a long row :)
when on x86, 32bit userspace does not work with 64bit
kernel.  This time this is about aio requests.

An application submits some aio job, and it is returned
immediately (from io_getevents()) with EINVAL error.
Here's what it does (it's a printf in the application -
actual arguments as passed to io_submit() and actual
result received in io_getevents()):

io_submit: lio_opcode=7 reqprio=0 iov=0x9cd7018{0xf5599000,4096}, niov=1, offset=0
io_getevents: expected 4096 got -22 (EINVAL)

Note that it is not io_submit() which fails (that one
returns success) but io_getevents(), so it has to be
down the pipeline somewhere.

Can someone comment this please?  Somehow I was thinking this
codepath works as - I think anyway - I ran 32bit Oracle database
with aio support on 64bit kernel, but I may be mistaken.

Kernel is 2.6.33 from kernel.org.

Thanks!

/mjt

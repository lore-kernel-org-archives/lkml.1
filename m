Return-Path: <linux-kernel-owner+w=401wt.eu-S933063AbXBVMiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbXBVMiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 07:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933064AbXBVMiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 07:38:21 -0500
Received: from science.horizon.com ([192.35.100.1]:11559 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933062AbXBVMiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 07:38:20 -0500
Date: 22 Feb 2007 07:27:21 -0500
Message-ID: <20070222122721.12459.qmail@science.horizon.com>
From: linux@horizon.com
To: mingo@elte.hu
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

May I just say, that this is f***ing brilliant.
It completely separates the threadlet/fibril core from the (contentious)
completion notification debate, and allows you to use whatever mechanism
you like.  (fd, signal, kevent, futex, ...)

You can also add a "macro syscall" like the original syslet idea,
and it can be independent of the threadlet mechanism but provide the
same effects.

If the macros can be designed to always exit when donew, a guarantee
never to return to user space, then you can always recycle the stack
after threadlet_exec() returns, whether it blocked in the syscall or not,
and you have your original design.


May I just suggest, however, that the interface be:
	tid = threadlet_exec(...)
Where tid < 0 means error, tid == 0 means completed synchronously,
and tod > 0 identifies the child so it can be waited for?


Anyway, this is a really excellent user-space API.  (You might add some
sort of "am I synchronous?" query, or maybe you could just use gettid()
for the purpose.)

The one interesting question is, can you nest threadlet_exec() calls?
I think it's implementable, and I can definitely see the attraction
of being able to call libraries that use it internally (to do async
read-ahead or whatever) from a threadlet function.

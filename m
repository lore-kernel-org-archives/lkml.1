Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbYBWNh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbYBWNh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 08:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbYBWNhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 08:37:46 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:51937 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997AbYBWNhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 08:37:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=J7MzJKnRcFS/6HOwKwOM/t2DPs5AWRNaIf7I0Mt8cXjzF7pqidBlgT8udVY45r4kjfU9P2GvJ3sm7CCGBKvBBbz2sUjxaHJBeo9aK5rDoGo6UqafUAGW1szXJ4bdoBD4/ZNd+7PDxlhYN8lSq4j/5Njsy7H1k7FxoqIb3nJbSho=
Message-ID: <6278d2220802230537m810ce2che694159de3fc3318@mail.gmail.com>
Date: Sat, 23 Feb 2008 13:37:29 +0000
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Stephen Oberholtzer" <oliverklozoff@gmail.com>
Subject: Re: How to diagnose a process stuck in D state?
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On 22 Feb, 23:10, "Stephen Oberholtzer" <oliverklozoff@gmail.com> wrote:
> First off: I'm not subscribed to the list (I don't think I could
> handle the volume), so please make sure you CC me if you reply.
>
> I run an application on one of my machines; it often hangs, with the
> process stuck D state.  When this happens, the process sticks around
> until I reboot the machine.
>
> I have tried the following to start diagnosing the problem:
>
> * Running 'ps -axl' shows "-" in the wchan column.
> * The contents of /proc/pid/wchan say "_stext".
> * 'strace -p pid' says "Process pid attached - interrupt to quit" and
> stops responding.  Sending SIGINT and SIGTERM have no effect on the
> strace process, although kill -11 (SIGSEGV, my personal favorite) does
> work.
>
> This is very confusing.  I would greatly appreciate it if someone
> could tell me how a process can enter D state without being in a
> syscall, and what I can do to start tracking down the cause.

wchan shows where the process is sleeping - probably a kernel mutex or
lock here. This doesn't help much, but the stack signature will.

Enable and use the sys-request mechanism (via terminal, keyboard or
serial) eg sysrq-T to dump the stack frames of all processes,
including this.

Unsurprisingly, it's documented in the kernel Documentation directory.

> (By the way: This is on amd64, 2.6.23. I'm updating to 2.6.24.2 right
> now, on the off chance that whatever was causing the problem has been
> fixed.)

Daniel
-- 
Daniel J Blueman

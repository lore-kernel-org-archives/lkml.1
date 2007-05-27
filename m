Return-Path: <linux-kernel-owner+w=401wt.eu-S1751805AbXE0Ila@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbXE0Ila (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 04:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbXE0IlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 04:41:21 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:44133 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbXE0IlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 04:41:20 -0400
Message-ID: <4659442E.2060307@dgreaves.com>
Date: Sun, 27 May 2007 09:41:18 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
References: <4658B7DD.3060309@tmr.com>
In-Reply-To: <4658B7DD.3060309@tmr.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> Anyway, I pulled the plug on the UPS, and the system shut down. But when
> it powered up, it booted the default kernel rather than the test kernel,
> decided that it couldn't resume, and then did a cold boot.

Booting the machine isn't the kernel's job, it's the bootloader's job.

> I can bypass this by making the debug kernel the default, but WHY? Is
> the kernel not saved such that any kernel can be rolled back into memory
> and run? Actually, the answer is HELL NO, so I really ask if this is the
> intended mode of operation, that only the default boot kernel will restore.

Yes.

It is very dangerous to attempt a resume with a different kernel than the one
that has gone to sleep.
Different kernels may be compiled with different options that affect where or
how in-memory structures are saved.

So you suspend with a kernel which holds your filesystem data/cache/inodes at
0x1234000 and restore with a kernel that expects to see your filesystem data at
0x1235000.

Ouch.

Personally I think the kernel suspend should write a signature - similar to a
hash of the bzImage - into the suspend image so it won't even attempt a resume
if there's a mismatch. (Yes, I made this mistake once whilst playing with suspend).

David



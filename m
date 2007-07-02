Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbXGBSUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbXGBSUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 14:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbXGBSUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 14:20:49 -0400
Received: from 241-226.umostel.ru ([77.246.241.226]:57665 "EHLO mail.aknet.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbXGBSUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 14:20:48 -0400
Message-ID: <4689422E.5040503@aknet.ru>
Date: Mon, 02 Jul 2007 22:21:34 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: William Tambe <tambewilliam@gmail.com>
CC: Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org
Subject: Re: Concerning a post that you made about expandable anonymous shared
 mappings
References: <468562F6.4010604@gmail.com> <Pine.LNX.4.64.0707021619020.32337@blonde.wat.veritas.com> <4689375C.2090505@gmail.com>
In-Reply-To: <4689375C.2090505@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

William Tambe wrote:
> And it just doesn't make sens to have mmap() map ANONYMOUS shared memory 
> and mremap() not to expand it and make the expanded area available.
I agree with this, but the argument against
that approach was that then you can only
enlarge the backing-store, but never shrink.
I personally think it is a valid argument,
even though the problem is probably not very
important.
Also, you can't expand the SysV SHM with mremap
just as well - it will give you a SIGBUS too IIRC.
So for that discussion of 2004, I lost the
battle and was convinced that the proposed
approach is not very good...

> Would you happen to know how I can work around that issue for now, and 
> make writing in an expended area not to generate a Bus error?
Have you tried the Posix SHM instead? It works
very well for me. Back in 2004 the glibc had
bugs, so I couldn't easily use posix shm and
was thinking about the different approaches.
But now it should suffice.


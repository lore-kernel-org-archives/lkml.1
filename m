Return-Path: <linux-kernel-owner+w=401wt.eu-S1759833AbZASOVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833AbZASOVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbZASOUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:20:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44696 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbZASOUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:20:19 -0500
Message-ID: <49748C1B.8090205@redhat.com>
Date: Mon, 19 Jan 2009 15:20:11 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
       aarcange@redhat.com
Subject: Re: [PATCH v6 0/5] Add preadv & pwritev system calls.
References: <1232124344-25892-1-git-send-email-kraxel@redhat.com> <200901161852.04953.arnd@arndb.de> <4970DDF9.4090007@redhat.com>
In-Reply-To: <4970DDF9.4090007@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> If they are in the kernel there is no reason not to export them from
> glibc.

Great.

> But I have a general comment about all kinds of read syscalls.
> If think they have been misdesigned from day one and if we are going to
> add new ones we might want to fix them.
> 
> The problem is that they don't allow for zero-copy operations in enough
> cases.  The kernel is not free to store the data wherever it wants even
> if the userlevel code is fine with that.

[ ... more text snipped ... ]

I do see the point in adding a interface like this ...

>    ssize_t readz (int fd, void *buf, size_t len, void **res)

... to help the kernel do zero-copy I/O.

I think system calls for vector I/O are *not* the right place for that
though.  Usually applications use vectored I/O because they *do* care
about the place the data is stored, because vectored I/O allows them to
avoid copying data within the application.

cheers,
  Gerd



Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbZHXLE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbZHXLE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 07:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZHXLEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 07:04:51 -0400
Received: from lucidpixels.com ([75.144.35.66]:46786 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbZHXLEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 07:04:51 -0400
Date: Mon, 24 Aug 2009 07:04:52 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Christoph Hellwig <hch@infradead.org>
cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Kernel 2.6.30.4 XFS(..?) regression (& with/2.6.31-rc6)
In-Reply-To: <20090823224504.GA19942@infradead.org>
Message-ID: <alpine.DEB.2.00.0908240704130.9427@p34.internal.lan>
References: <alpine.DEB.2.00.0908110624420.22426@p34.internal.lan> <20090816022331.GA2309@infradead.org> <alpine.DEB.2.00.0908171024380.12533@p34.internal.lan> <alpine.DEB.2.00.0908220624440.30321@p34.internal.lan> <20090822142550.GA10003@infradead.org>
 <alpine.DEB.2.00.0908221044420.30321@p34.internal.lan> <20090822201558.GA17955@infradead.org> <alpine.DEB.2.00.0908221645440.20848@p34.internal.lan> <20090822205502.GA18904@infradead.org> <alpine.DEB.2.00.0908221659030.23463@p34.internal.lan>
 <20090823224504.GA19942@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 23 Aug 2009, Christoph Hellwig wrote:

> Ok, let's see where errors could happen then.
>
> There are four theoretical possibilities:
>
> (a) XFS
> (b) loop driver
> (c) crypto loop code
> (d) block layer
>
> Or combinations thereof.
>
> I would take (a) and (d) as more unlikely as they tend to get used much
> more and I would have heard more bug reports already.
>
> The cryptoloop code hasn't changed at all since 2.6.29.
>
> The loop code howver has a very interesting commit just after 2.6.39:
>
> commit 68db1961bbf4e16c220ccec4a780e966bc1fece3
> Author: Nikanth Karthikesan <knikanth@suse.de>
> Date:   Tue Mar 24 12:29:54 2009 +0100
>
>    loop: support barrier writes
>
> Can you try reverting this one (it cleanly reverse-applies against
> 2.6.30 and current mainline) and see if that makes a difference?
>

Hello Christoph,

# patch -p1 -R < ../unpatch.patch
patching file drivers/block/loop.c
Hunk #1 succeeded at 473 (offset -1 lines).
Hunk #2 succeeded at 804 (offset -22 lines).
#

Patched, we'll see if the problem recurs.. thanks!

Justin.

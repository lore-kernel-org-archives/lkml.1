Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab0CJAur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 19:50:47 -0500
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4280 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab0CJAuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 19:50:44 -0500
Message-ID: <4B96ECDD.1070006@gmail.com>
Date: Wed, 10 Mar 2010 01:50:37 +0100
From: M vd S <mvds.00@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: O_NONBLOCK is NOOP on block devices
References: <4B904D98.50602@gmail.com> <4B9060DE.4080104@gmail.com>
In-Reply-To: <4B9060DE.4080104@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> mmap(2) / madvise(2) / mincore(2) may be a way around things (although 
> non-atomic), but I haven't tested it yet. It might also solve the 
> problem that started this thread, at least for the reading part of it. 
> Writing a small read() like function that operates through mmap() 
> doesn't seem too complicated. As for writing, you could use msync() 
> with MS_ASYNC to initiate a write. I'm not sure how to find out if a 
> write has indeed taken place, but at least initiating a non-blocking 
> write is possible. munmap() might then still block.
>

For the record I would like to share my very positive experience with 
the approach described. Thanks to 64 bit addressing you can mmap() an 
entire block device, and madvise() and mincore() work like you would 
expect them to. I haven't tried writing.

I also briefly tried aio_* and the libaio interface. The former is not 
really asynchronous - all requests are put in one separate thread where 
they will be executed in order, i.e. blocking, so you don't get any 
advantage from NCQ or data that was cached by the disk or the kernel. 
The latter apparently ends in an io_submit() which will block until all 
queued reads are finished, but I might have missed something there.

Imagine the orderly world in which O_NONBLOCK would make syscalls 
actually non-blocking...

Cheers,
M.


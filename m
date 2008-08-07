Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbYHGA23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbYHGA23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 20:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbYHGAZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 20:25:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38007 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbYHGAZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 20:25:14 -0400
Message-ID: <489A40FF.1000508@zytor.com>
Date: Wed, 06 Aug 2008 17:25:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: initramfs optimization suggestions
References: <ac9c93b10808050042u496bfa10nad7962eb0e9ec015@mail.gmail.com>
In-Reply-To: <ac9c93b10808050042u496bfa10nad7962eb0e9ec015@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Meulenbroeks wrote:
> 
> First proposal:
> ==========
> 
> initramfs is build from a compressed cpio archive.
> Proposal is to introduce a build option to make the compression and
> decompression optional.
> Rationale 1: could be faster as it trades off I/O time (to read the
> image) against decompression time
> Rationale 2: for architectures that use compressed images (bzImage)
> actually we compress twice, which is not really efficient.
> 
> I can implement this, but before spending time on it I would like to know if
> a) people consider this a good idea
> b) no one else already has doen this.
>

It already is optional.  If you don't want to compress it, don't.

Perhaps what you are referring to is the initramfs that is optionally 
built out of the kernel tree?

You are (correctly) pointing out that if the image is already 
compressed, it doesn't gain from additional compression, but that would 
increase the operational memory footprint during expansion.

> 
> Second proposal:
> ============
> 
> after decompressing the cpio archive all files are made using
> sys_open/sys_write/sys_close and friends.
> This implies that a lot of system calls and data copying is done.
> It would be nice if that could be avoided.
> I'm not fully into all details of how ramfs is implemented, but would
> it be possible to e.g. dump all blocks of a tmp ram fs into a data
> structure (e.g.an array of blocks) while making the kernel, and while
> booting the kernel initialise the fs cache with these data? (I guess
> this would be around fs/dcache.c; I understand the data here is
> kmalloc-ed, but it might be possible to initialise the cache with
> pointers to that data structure; due to the nature of ramfs they won't
> be deallocated anyway I assume).
> Does this sound feasible? Hidden snags? Appreciate your
> opinion/feedback/suggestions.
> 

The current code has a lot of advantages in terms of code complexity, 
however.  Your proposal would come with a dramatic increase in complexity.

	-hpa


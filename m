Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbYJIUn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbYJIUn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 16:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbYJIUnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 16:43:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39402 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbYJIUnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 16:43:20 -0400
Message-ID: <48EE6CD6.10007@zytor.com>
Date: Thu, 09 Oct 2008 13:43:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: mtk.manpages@gmail.com, Al Viro <viro@zeniv.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: dup2() vs dup3() inconsistency when
References: <cfd18e0f0810090510i87f088fi9eeea829ae2b58c1@mail.gmail.com> <48EE3D84.6000003@zytor.com> <48EE6A2B.8030005@redhat.com>
In-Reply-To: <48EE6A2B.8030005@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> H. Peter Anvin wrote:
>> The dup2() behavior comes from the logical consequence of dup2()'s
>> "close on reuse"; one would think it would be logical for dup3() to
>> behave the same way.
> 
> No.  We deliberately decided on this change.  Otherwise, what is the
> result of dup3(fd, fd, O_CLOEXEC)?  There is no reason to use
> dup2(fd,fd), so why the hell somebody wants to defend this is beyond me.
> 

The result of dup3(fd, fd, O_CLOEXEC) is to set the O_CLOEXEC flag on fd.

The behaviour of dup2() is functionally the following:

1. Duplicate the file descriptor from file_table[oldfd].
2. If file_table[newfd] is in use, close it.
3. Install the duplicate file descriptor at file_table[newfd].

Step (2) could be considered a bit dubious, but the behaviour of 
dup2(fd, fd) is a direct consequence of the chosen semantics.

	-hpa

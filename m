Return-Path: <linux-kernel-owner+w=401wt.eu-S1760134AbYJIRWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134AbYJIRWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 13:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbYJIRVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 13:21:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35532 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbYJIRVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:21:52 -0400
Message-ID: <48EE3D84.6000003@zytor.com>
Date: Thu, 09 Oct 2008 10:21:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: mtk.manpages@gmail.com
CC: Al Viro <viro@zeniv.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: dup2() vs dup3() inconsistency when
References: <cfd18e0f0810090510i87f088fi9eeea829ae2b58c1@mail.gmail.com>
In-Reply-To: <cfd18e0f0810090510i87f088fi9eeea829ae2b58c1@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk wrote:
> Al,
> 
> your 2008-07-26 commit 6c5d0512a091480c9f981162227fdb1c9d70e555 for
> fs/fcntl.c:sys_dup3 contains
> 
> +       if (unlikely(oldfd == newfd))
> +               return -EINVAL;
> 
> This makes dup2() and dup3() differ with respect to the oldfd==newfd
> case (dup2() becomes a no-op, just returning oldfd, dup3() gives the
> EINVAL error.
> 
> Your commit log doesn't explain the rationale for this change.  What
> is it?  (I could guess that it is to error on a case that may be a
> user programming error, but I want to check this with you, so that I
> add the right text to the man page.)
> 

The dup2() behavior comes from the logical consequence of dup2()'s 
"close on reuse"; one would think it would be logical for dup3() to 
behave the same way.

	-hpa

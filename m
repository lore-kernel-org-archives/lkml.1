Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbYJIU57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbYJIU57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 16:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756259AbYJIU5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 16:57:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58087 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295AbYJIU5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 16:57:48 -0400
Message-ID: <48EE703C.7070901@zytor.com>
Date: Thu, 09 Oct 2008 13:57:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: mtk.manpages@gmail.com, Al Viro <viro@zeniv.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: dup2() vs dup3() inconsistency when
References: <cfd18e0f0810090510i87f088fi9eeea829ae2b58c1@mail.gmail.com> <48EE3D84.6000003@zytor.com> <48EE6A2B.8030005@redhat.com> <48EE6CD6.10007@zytor.com> <48EE6F22.5070306@redhat.com>
In-Reply-To: <48EE6F22.5070306@redhat.com>
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
>> The result of dup3(fd, fd, O_CLOEXEC) is to set the O_CLOEXEC flag on fd.
> 
> That's bad and disregarded by Al and myself because it is one and the
> same descriptor and therefore it changes the source descriptor.

It's not the source descriptor, per se, it is the "new" descriptor, 
which happens to have a side effect of closing the "old" descriptor.

>> Step (2) could be considered a bit dubious, but the behaviour of
>> dup2(fd, fd) is a direct consequence of the chosen semantics.
> 
> The behavior of dup2(fd,fd) is just a result of an accident in the
> original implementation.  It makes no sense and the mistake doesn't have
> to be repeated.

Inconsistency is bad, too, and one could *definitely* argue that the 
fundamental problem is the one of closing a pre-existing descriptor 
rather than forcing the user to do that explicitly if that behaviour was 
desired.

	-hpa

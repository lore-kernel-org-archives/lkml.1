Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYH1STH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYH1STH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbYH1SS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:18:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:37007 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbYH1SSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:18:55 -0400
Message-ID: <48B6EBBD.6050406@kernel.org>
Date: Thu, 28 Aug 2008 20:17:33 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: greg@kroah.com, fuse-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org> <48B6E801.9080102@kernel.org> <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 18:18:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>> If you're worried about the double copying due to performance reasons,
>> what we can do is implementing userspace to userspace copying.  I just
>> took easier path of copying twice as u-u copy can't be done using the
>> existing FUSE mechanics.
> 
> How about not copying anything in the kernel, just passing the virtual
> address to the filesystem?  It can get/modify the data of the calling
> task by mapping /proc/pid/mem.  Ugly, yes, but ioctls are inherently
> ugly.

Hmmm... I was trying to stay within similar operation mechanics as other
ops.  Directly accessing the caller's memory has performance benefits
but that benefit can also be used by reads and writes.  So, if we're
gonna do direct memory access, maybe doing it in more generic way is a
better idea?

Thanks.

-- 
tejun

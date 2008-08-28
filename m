Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbYH1UVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbYH1UVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbYH1UVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:21:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33272 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbYH1UVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:21:39 -0400
Message-ID: <48B708C4.4000405@kernel.org>
Date: Thu, 28 Aug 2008 13:21:24 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: tj@kernel.org, fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <48B6EC83.1070207@kernel.org> <48B6EE36.5070209@kernel.org> <48B6F7C5.3020204@kernel.org> <E1KYn0U-00047F-Qa@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KYn0U-00047F-Qa@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> On Thu, 28 Aug 2008, H. Peter Anvin wrote:
>> Tejun Heo wrote:
>>> Ah.... funky.  If this retry thing is too repulsive, I guess the best
>>> alternative would be directly accessing caller's memory as Miklos suggested.
>>>
>> Be careful -- there are some serious dragons there in the presence of 
>> multiple threads.
> 
> OK, it should map /proc/pid/task/tid/mem.  Or rather
> /proc/tid/task/tid/mem, as the pid (tgid) of the caller is not
> currently passed to the filesystem.
> 

Uhm, no.  You can still have it change underneath you as long as you 
have any thread of execution with access to the same memory.

This is *hard* to get right, and we screw this up in the kernel with 
painful regularity.  The throught of having user-space processes, which 
don't have access to the kernel locking primitives and functions like 
copy_from_user() dealing with this stuff scares me crazy.

That is why I'm suggesting using an in-kernel linearizer.

	-hpa

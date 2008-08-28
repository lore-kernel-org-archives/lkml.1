Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbYH1S3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbYH1S3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbYH1S32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:29:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:48160 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbYH1S31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:29:27 -0400
Message-ID: <48B6EE36.5070209@kernel.org>
Date: Thu, 28 Aug 2008 20:28:06 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@kernel.org>
CC: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <48B6EC83.1070207@kernel.org>
In-Reply-To: <48B6EC83.1070207@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 18:29:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Tejun Heo wrote:
>> ioctl support is tricky to implement because only the ioctl
>> implementation itself knows which memory regions need to be read
>> and/or written.  To support this, fuse client can request retry of
>> ioctl specifying memory regions to read and write.  Deep copying
>> (nested pointers) can be implemented by retrying multiple times
>> resolving one depth of dereference at a time.
> 
> Okay, I'm going to say it... wouldn't it be better to have some kind of
> data structure description language which the userspace can register
> with the kernel to linearize the data on a per-ioctl basis (kind of like
> rpcgen)?

Ah.... funky.  If this retry thing is too repulsive, I guess the best
alternative would be directly accessing caller's memory as Miklos suggested.

Thanks.

-- 
tejun

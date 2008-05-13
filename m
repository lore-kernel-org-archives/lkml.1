Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbYEMMuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbYEMMuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbYEMMtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:49:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbYEMMtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:49:50 -0400
Message-ID: <48298E31.7050205@redhat.com>
Date: Tue, 13 May 2008 07:48:49 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Tiger Yang <tiger.yang@oracle.com>
CC: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext3/4: fix uninitialized bs in ext3/4_xattr_set_handle()
References: <4827B878.50903@oracle.com> <4828DE73.2070001@redhat.com> <482947C3.9040601@oracle.com>
In-Reply-To: <482947C3.9040601@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tiger Yang wrote:
> Hi, Eric,
> 
> I don't have tesecase about this bug. I did the test manually. I use 
> khexedit to confirm the attributes whether in inody or block.
> The problem about this bug is we want to replace an existing attribute 
> in ibody with big size value which larger than free space in ibody.
> Because we didn't do block_find(), so the struct bs have not been 
> initialized. Then when we try to set attribute in block by block_set(), 
> we find bs->base is empty, we need alloc a new block for attributes. The 
> old block pointed by i_file_acl will lost with attributes in it.

Thanks, I'll go for a reproducer.  We use xattrs a lot for selinux in
Red Hat and Fedora, so a little surprised I haven't seen this bug... or
maybe it explains some bugs I haven't yet figured out ... :)

Thanks,
-Eric

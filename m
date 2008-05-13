Return-Path: <linux-kernel-owner+w=401wt.eu-S1758922AbYEMHsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbYEMHsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 03:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756589AbYEMHsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 03:48:36 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:24325 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331AbYEMHsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 03:48:35 -0400
Message-ID: <482947C3.9040601@oracle.com>
Date: Tue, 13 May 2008 15:48:19 +0800
From: Tiger Yang <tiger.yang@oracle.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext3/4: fix uninitialized bs in ext3/4_xattr_set_handle()
References: <4827B878.50903@oracle.com> <4828DE73.2070001@redhat.com>
In-Reply-To: <4828DE73.2070001@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Eric,

I don't have tesecase about this bug. I did the test manually. I use 
khexedit to confirm the attributes whether in inody or block.
The problem about this bug is we want to replace an existing attribute 
in ibody with big size value which larger than free space in ibody.
Because we didn't do block_find(), so the struct bs have not been 
initialized. Then when we try to set attribute in block by block_set(), 
we find bs->base is empty, we need alloc a new block for attributes. The 
old block pointed by i_file_acl will lost with attributes in it.

Best regards,
tiger

Eric Sandeen wrote:
> Tiger Yang wrote:
>   
>> Hi,
>> I met a bug when I try to replace a xattr entry in ibody with a big size 
>> value. But in ibody there has no space for the new value. So it should 
>> set new xattr entry in block and remove the old xattr entry in ibody.
>>
>> Best regards,
>> tiger
>>
>>     
>
> Tiger, do you have a testcase handy to demonstrate this?
>
> Is the new, large out-of-inode xattr unique so that it does not match
> any existing attribute block, I assume?
>
> Thanks,
>
> -Eric
>   

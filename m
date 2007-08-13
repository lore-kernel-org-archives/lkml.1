Return-Path: <linux-kernel-owner+w=401wt.eu-S972110AbXHMMk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972110AbXHMMk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S941012AbXHMHPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:15:39 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:15453 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S941026AbXHMHPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:15:36 -0400
Message-ID: <46C00446.7030703@openvz.org>
Date: Mon, 13 Aug 2007 11:12:06 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: akpm@osdl.org, devel@openvz.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, oleg@tv-sign.ru, sukadev@us.ibm.com
Subject: Re: [PATCH 3/20] Introduce MS_KERNMOUNT flag
References: <46BC506B.mailGIV1AXDXM@openvz.org> <20070811034721.GB22216@infradead.org>
In-Reply-To: <20070811034721.GB22216@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, Aug 10, 2007 at 03:47:55PM +0400, xemul@openvz.org wrote:
>> This flag tells the .get_sb callback that this is a kern_mount() call
>> so that it can trust *data pointer to be valid in-kernel one. If this
>> flag is passed from the user process, it is cleared since the *data
>> pointer is not a valid kernel object.
>>
>> Running a few steps forward - this will be needed for proc to create the
>> superblock and store a valid pid namespace on it during the namespace
>> creation. The reason, why the namespace cannot live without proc mount
>> is described in the appropriate patch.
> 
> I don't like this at all.  We should never pass kernel and userspace
> addresses through the same pointer.  Maybe add an additional argument
> to the get_sb prototype instead.  But this whole idea of mounting /proc
> from kernelspace sounds like a really bad idea to me.  /proc should
> never be mounted from the kernel but always normally from userspace.

Why then is it mounted in proc_root_init()?

Thanks,
Pavel

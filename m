Return-Path: <linux-kernel-owner+w=401wt.eu-S1761659AbYGBNVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659AbYGBNVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 09:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbYGBNVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 09:21:03 -0400
Received: from smtp.nokia.com ([192.100.122.233]:30296 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbYGBNVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 09:21:00 -0400
Message-ID: <486B8034.1020904@nokia.com>
Date: Wed, 02 Jul 2008 16:18:44 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-kernel@vger.kernel.org, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, ext-Adrian.Hunter@nokia.com
Subject: Re: Is VFS behavior fine?
References: <486B419F.7050407@nokia.com> <E1KE07d-0007wx-M2@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KE07d-0007wx-M2@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Jul 2008 13:20:42.0685 (UTC) FILETIME=[6DBAF6D0:01C8DC46]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>> I may just say that I fixed this in UBIFS by not calling
>> 'd_splice_alias()' for not found dentries if the parent
>> directory inode has 'n_link' = 0. However, ext[23] always
>> call 'd_splice_alias()' for not found direntries (passing
>> NULL as the 'inode' parameter).
>>
>> Again, I am not 100% sure this is the right fix, because
>> I suspect this should be "fixed" in VFS. I tried to do this
>> and I have a small VFS patch, but it is probably incorrect.
> 
> The correct fix IMO is to make lookup return ENOENT on an IS_DEADDIR()
> inode, before even trying to create the child dentry.

Sounds correct, thanks for the replay.

> Untested patch attached.

Looks fine. Tried it, looks fine and solves my problem. Ran some
of my tests and they did not fail.

Hopefully this patch will make his way to mainline. Thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

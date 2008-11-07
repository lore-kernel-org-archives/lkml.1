Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbYKGJBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbYKGJBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYKGJBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:01:38 -0500
Received: from li2-213.members.linode.com ([69.56.173.213]:60799 "EHLO
	mail.zilogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbYKGJBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:01:37 -0500
X-Greylist: delayed 1880 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Nov 2008 04:01:37 EST
Message-ID: <4913FEE1.9030807@bravegnu.org>
Date: Fri, 07 Nov 2008 14:10:01 +0530
From: Vijay Kumar <vijaykumar@bravegnu.org>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: "J.R. Mauro" <jrm8005@gmail.com>
CC: Christoph Hellwig <hch@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "William L. Irwin" <wli@holomorphy.com>, jayakumar.lkml@gmail.com,
       sparclinux@vger.kernel.org
Subject: Re: sparc/staging compile error
References: <20081106163626.2306ad75.sfr@canb.auug.org.au>	 <20081106063709.GB7728@kroah.com>	 <18706.51153.342079.586525@cargo.ozlabs.ibm.com>	 <3aaafc130811060606p1dfbf12cr8c0dc8cd310d0279@mail.gmail.com>	 <20081106173224.GA25767@infradead.org> <3aaafc130811060936u371e8b9eyccd0c52693f4c433@mail.gmail.com>
In-Reply-To: <3aaafc130811060936u371e8b9eyccd0c52693f4c433@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.R. Mauro wrote:
> On Thu, Nov 6, 2008 at 12:32 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Thu, Nov 06, 2008 at 09:06:36AM -0500, J.R. Mauro wrote:
>>> static int poch_ioctl(struct inode *inode, struct file *filp,
>>>                       unsigned int cmd, unsigned long arg)
>>> {
>>> /* ---snip---*/
>>>         case POCH_IOC_SYNC_GROUP_FOR_USER:
>>>         case POCH_IOC_SYNC_GROUP_FOR_DEVICE:
>>>                 vms = find_vma(current->mm, arg);
>>>                 if (!vms)
>>>                         /* Address not mapped. */
>>>                         return -EINVAL;
>>>                 if (vms->vm_file != filp)
>>>                         /* Address mapped from different device/file. */
>>>                         return -EINVAL;
>>>
>>>                 flush_cache_range(vms, arg, arg + channel->group_size);
>> This doesn't look like something a driver should ever do.  Could someone
>> explain what it's trying to do from a high level point of view?
>
> CC'd driver maintainers mentioned in the README

May be the code is not doing what is supposed to do, but here is what the 
driver is trying to achieve:

The driver allocates a set of buffers for DMA. These buffers are mapped 
into user space, when the user does an mmap. In transmit, when the user 
space writes to these buffers, the data has to reach physical memory so 
that the device can access them. For receive, the cache has to be 
invalidated before the user space reads the buffer.

Do let me know if further clarification is required. Any inputs and 
suggestions are welcome.

BTW, please do send in the compiler error message.

Regards,
Vijay

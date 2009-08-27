Return-Path: <linux-kernel-owner+w=401wt.eu-S1752074AbZH0MQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbZH0MQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZH0MQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:16:08 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:59165 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbZH0MQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:16:08 -0400
Message-ID: <4A967909.1040609@oss.ntt.co.jp>
Date: Thu, 27 Aug 2009 21:16:09 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: t-sato@yk.jp.nec.com, m-hamaguchi@ys.jp.nec.com,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC, PATCH] filesystem freeze: fix sys_umount induced perpetual
 freeze
References: <4A94C151.8020900@oss.ntt.co.jp> <20090826173839.GA20175@lst.de> <4A965BD1.205@oss.ntt.co.jp> <20090827115412.GA8326@lst.de>
In-Reply-To: <20090827115412.GA8326@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Aug 27, 2009 at 07:11:29PM +0900, Fernando Luis V?zquez Cao wrote:
>> Thank you for the pointers. I gave those patches a spin, but it seems
>> the umount case is not being tackled. I suggest rejecting the umount
>> for frozen filesystems. What do you think?
>>
>> I will be replying to this email with a forward port of your patches
>> along with my own patches that fix the locking for umount and add a
>> new ioctl to check the freeze state of the filesystem (this is helpful
>> to create clean resource agents for HA solutions).
> 
> I think we should just reject the umount for a forzen filesystem with
> -EBUSY like I do for remount in those patches.  I somehow thought I did
> this but didn't.  Is that good for your use case?

Yes, absolutely. Today I will be sending patches that do just that.
Hopefully you will find the new ioctl (ISFROZEN) I am adding
helpful too.

Thanks,

Fernando

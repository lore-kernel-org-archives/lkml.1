Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbZDGTqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbZDGTqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbZDGTqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:46:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49018 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbZDGTqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:46:14 -0400
Message-ID: <49DBAD5B.7010107@garzik.org>
Date: Tue, 07 Apr 2009 15:45:31 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ray Lee <ray-lk@madrabbit.org>, Hua Zhong <hzhong@gmail.com>,
       Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>  <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain>  <20090406151054.GD5178@kernel.dk> <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>  <20090406183157.GD7376@mit.edu> <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>  <002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu>  <003001c9b6ff$a9259ce0$fb70d6a0$@com> <2c0942db0904061504l6504934bi446f7425fcd38470@mail.gmail.com> <alpine.LFD.2.00.0904061509020.7443@localhost.localdomain> <alpine.LFD.2.00.0904061604410.8214@localhost.localdomain> <49DB56B8.1060805@rtr.ca> <alpine.LFD.2.00.0904070727260.4010@localhost.localdomain> <49DBA87F.6070501@rtr.ca>
In-Reply-To: <49DBA87F.6070501@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Linus Torvalds wrote:
>>
>> On Tue, 7 Apr 2009, Mark Lord wrote:
>>> What happens with ext3 "writeback", and ext4 "whatever",
>>> when one does the quickie reboot method:
>>>
>>>   ALT-SYSRQ-S ALT-SYSRQ-U ALT-SYSRQ-S ALT-SYSRQ-B
>>>
>>> ???
>>
>> Since 's' syncs (I think 'u' does too, as part of making things 
>> read-only), the data blocks will be on disk after the boot regardless 
>> of any other ordering.
> ..
> 
> I was thinking more about delayed allocation in ext4, though.
> If it hasn't allocated the blocks, then sync() has nothing to write out.
> Or do they have hooks into the block layer to force alloc/commit when
> somebody does a sync() ??

sync(2) doesn't just sync dirty buffers...  it sync's inodes, which 
pokes the filesystem to do something intelligent, perhaps triggering (a) 
write-out of data, (b) write-out of zeroed blocks, or (c) annotation in 
filesystem metadata that certain blocks are allocated, but not initialized.

	Jeff




Return-Path: <linux-kernel-owner+w=401wt.eu-S1751710AbZH0T0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbZH0T0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 15:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZH0T0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 15:26:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34663 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbZH0T0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 15:26:33 -0400
Message-ID: <4A96DDE0.9090306@garzik.org>
Date: Thu, 27 Aug 2009 15:26:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, chris.mason@oracle.com, tytso@mit.edu,
       adilger@sun.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
       mfasheh@suse.com, joel.becker@oracle.com
Subject: Re: notes on volatile write caches vs fdatasync
References: <20090827011624.GA10405@lst.de> <20090827130252.GC14240@duck.novell.com> <20090827184948.GA1367@lst.de>
In-Reply-To: <20090827184948.GA1367@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2009 02:49 PM, Christoph Hellwig wrote:
> On Thu, Aug 27, 2009 at 03:02:52PM +0200, Jan Kara wrote:
>>    I've noticed this as well when we were tracking some problems Pavel
>> Machek found with his USB stick. I even wrote a patch at the time
>>    http://osdir.com/ml/linux-ext4/2009-01/msg00015.html
>> but it somehow died out. Now, the situation should be simpler with
>> fsync paths cleaned up... BTW: People wanted this to be configurable per
>> block device which probably makes sence...
>
> Yeah, that patch is pretty ugly.  We need to do these cache flushes
> in ->fsync (and ->sync_fs if any filesystem really doesn't guarantee to
> issue  transaction there after data has been written).  Adding it
> to simple_fsync too sounds good to me.

Agreed.  That was the direction I was heading with my patch[1].  Last 
feedback I got on that was needing to add a knob to optionally disable 
this new cache-flush behavior.

	Jeff



[1] http://lkml.org/lkml/2009/3/27/366

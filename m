Return-Path: <linux-kernel-owner+w=401wt.eu-S1751667AbZEDDXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbZEDDXo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 23:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbZEDDXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 23:23:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62766 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbZEDDXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 23:23:34 -0400
Message-ID: <49FE5FEB.6040207@cn.fujitsu.com>
Date: Mon, 04 May 2009 11:24:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ryo Tsuruta <ryov@valinux.co.jp>
CC: Alan.Brunelle@hp.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH dm-ioband] Added in blktrace msgs for dm-ioband
References: <49F23379.4010607@hp.com> <20090427.184417.189717449.ryov@valinux.co.jp>
In-Reply-To: <20090427.184417.189717449.ryov@valinux.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryo Tsuruta wrote:
> Hi Alan,
> 
>> Hi Ryo -
>>
>> I don't know if you are taking in patches, but whilst trying to uncover
>> some odd behavior I added some blktrace messages to dm-ioband-ctl.c. If
>> you're keeping one code base for old stuff (2.6.18-ish RHEL stuff) and
>> upstream you'll have to #if around these (the blktrace message stuff
>> came in around 2.6.26 or 27 I think).
>>
>> My test case was to take a single 400GB storage device, put two 200GB
>> partitions on it and then see what the "penalty" or overhead for adding
>> dm-ioband on top. To do this I simply created an ext2 FS on each
>> partition in parallel (two processes each doing a mkfs to one of the
>> partitions). Then I put two dm-ioband devices on top of the two
>> partitions (setting the weight to 100 in both cases - thus they should
>> have equal access).
>>
>> Using default values I was seeing /very/ large differences - on the
>> order of 3X. When I bumped the number of tokens to a large number
>> (10,240) the timings got much closer (<2%). I have found that using
>> weight-iosize performs worse than weight (closer to 5% penalty).
> 
> I could reproduce similar results. One dm-ioband device seems to stop
> issuing I/Os for a few seconds at times. I'll investigate more on that.
>  
>> I'll try to formalize these results as I go forward and report out on
>> them. In any event, I thought I'd share this patch with you if you are
>> interested...
> 
> Thanks. I'll include your patche into the next release.
>  

IMO we should use TRACE_EVENT instead of adding new blk_add_trace_msg().

>> Here's a sampling from some blktrace output (sorry for the wrapping) - I
>> should note that I'm a bit scared to see such large numbers of holds
>> going on when the token count should be >5,000 for each device...
>> Holding these back in an equal access situation is inhibiting the block
>> I/O layer to merge (most) of these (as mkfs performs lots & lots of
>> small but sequential I/Os).


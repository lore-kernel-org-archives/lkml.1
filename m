Return-Path: <linux-kernel-owner+w=401wt.eu-S1751655AbZIHTYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbZIHTYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbZIHTYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:24:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbZIHTYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:24:51 -0400
Message-ID: <4AA6AF58.3050501@redhat.com>
Date: Tue, 08 Sep 2009 15:24:08 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Ryo Tsuruta <ryov@valinux.co.jp>
CC: vgoyal@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, agk@redhat.com, akpm@linux-foundation.org,
       nauman@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com
Subject: Re: Regarding dm-ioband tests
References: <20090904231129.GA3689@redhat.com>	<20090907.200222.193693062.ryov@valinux.co.jp>	<4AA51065.6050000@redhat.com> <20090908.120119.71095369.ryov@valinux.co.jp>
In-Reply-To: <20090908.120119.71095369.ryov@valinux.co.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryo Tsuruta wrote:
> Rik van Riel <riel@redhat.com> wrote:

>> Are you saying that dm-ioband is purposely unfair,
>> until a certain load level is reached?
> 
> Not unfair, dm-ioband(weight policy) is intentionally designed to
> use bandwidth efficiently, weight policy tries to give spare bandwidth
> of inactive groups to active groups.

This sounds good, except that the lack of anticipation
means that a group with just one task doing reads will
be considered "inactive" in-between reads.

This means writes can always get in-between two reads,
sometimes multiple writes at a time, really disadvantaging
a group that is doing just disk reads.

This is a problem, because reads are generally more time
sensitive than writes.

>>> We regarded reducing throughput loss rather than reducing duration
>>> as the design of dm-ioband. Of course, it is possible to make a new
>>> policy which reduces duration.
>> ... while also reducing overall system throughput
>> by design?
> 
> I think it reduces system throughput compared to the current
> implementation, because it causes more overhead to do fine grained
> control. 

Except that the io scheduler based io controller seems
to be able to enforce fairness while not reducing
throughput.

Dm-ioband would have to address these issues to be a
serious contender, IMHO.

-- 
All rights reversed.

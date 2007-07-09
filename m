Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbXGIB7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbXGIB7t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 21:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757431AbXGIB7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 21:59:42 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:25503 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757305AbXGIB7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 21:59:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=KKnBrsVD+tT2LrWAucuvOM8MBXGm0fbdXMYkVr4J44goqYgE4W9yqZY36XxksgP/tnYejzXca+geU9X9BRKaijRUGpiUkLOHRTyQptUgpZuZ5JqZEFnjlUsrmyRmohhH05uQ0XcNYgx+U7oopsMHzdW5kWOKFaaRNObY3HB5mDs=  ;
X-YMail-OSG: DZ1843YVM1mHM4LT2OXNgyAjOwnBruPbbyaEYjuiHizhoBAcRNKMpwzbgFqcfS164P7X7wA2BDpueC73TqFqOvjFr9McLxpx0EeNr9pfvucTk6mawAE-
Message-ID: <46919688.1050005@yahoo.com.au>
Date: Mon, 09 Jul 2007 11:59:36 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Flavio Curti <lists.fcu@no-way.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: panics with 16port Promise Supertrack EX Controller
References: <20070708225246.GD16285@no-way.org> <6bffcb0e0707081620pf4afd46re9e74e18518b352a@mail.gmail.com>
In-Reply-To: <6bffcb0e0707081620pf4afd46re9e74e18518b352a@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Hi Flavio,
> 
> On 09/07/07, Flavio Curti <lists.fcu@no-way.org> wrote:
> 
>> Hello
>>
>> I have a problem with a server running 2.6.22rc4.
> 
> 
> Jul  8 00:19:13 dorade.cyberlink.ch EFLAGS: 00210046   
> (2.6.22-rc7-dorade #1)
> 
> Is this a regression?
> 
>> The machine panics
>> after some days of running fine, the machine inst heavy loaded.
>>
>> The Controller detects as stex device:
>>
>> scsi0 : stex
>> scsi 0:0:0:0: Direct-Access Promise 1X2 Mirror      1.10 PQ: 0 ANSI: 3
>> scsi 0:0:2:0: Direct-Access Promise  12+2 Disk RAID6  1.10 PQ: 0 ANSI: 3
>> scsi 0:0:16:0: Processor Promise RAID Console     1.00 PQ: 0 ANSI: 3
>> sd 0:0:0:0: [sda] 976642048 512-byte hardware sectors (500041 MB)
>> sd 0:0:0:0: [sda] Write Protect is off
>> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
>> support DPO or FUA
>> sd 0:0:0:0: [sda] 976642048 512-byte hardware sectors (500041 MB)
>> sd 0:0:0:0: [sda] Write Protect is off
>> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
>> support DPO or FUA
>>  sda: sda1 sda2
>> sd 0:0:0:0: [sda] Attached SCSI disk
>> sd 0:0:2:0: [sdb] Very big device.  Trying to use READ CAPACITY(16).
>> sd 0:0:2:0: [sdb] 11719704576 512-byte hardware sectors (6000489 MB)
>> sd 0:0:2:0: [sdb] Write Protect is off
>> sd 0:0:2:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
>> support DPO or FUA
>> sd 0:0:2:0: [sdb] Very big device.  Trying to use READ CAPACITY(16).
>> sd 0:0:2:0: [sdb] 11719704576 512-byte hardware sectors (6000489 MB)
>> sd 0:0:2:0: [sdb] Write Protect is off
>> sd 0:0:2:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
>> support DPO or FUA
>>  sdb: sdb1
>> sd 0:0:2:0: [sdb] Attached SCSI disk
>> sd 0:0:0:0: Attached scsi generic sg0 type 0
>> sd 0:0:2:0: Attached scsi generic sg1 type 0
>> scsi 0:0:16:0: Attached scsi generic sg2 type 3
>>
>> Im not sure where the problem is (controller/lvm/ext3), so if anyone has
>> an idea, Im happy to try it out...
> 
> 
> kernel BUG at block/as-iosched.c:1084!
> 
> BUG_ON(RB_EMPTY_ROOT(&ad->sort_list[REQ_ASYNC]));

Could be a bug in the driver that just happens to be caught by AS checks.
If you could test another scheduler (boot with elevator=deadline or elevator=cfq),
it might help give us an idea.

-- 
SUSE Labs, Novell Inc.

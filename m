Return-Path: <linux-kernel-owner+w=401wt.eu-S1755800AbXFZDH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbXFZDH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 23:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbXFZDHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 23:07:50 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:49014 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752293AbXFZDHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 23:07:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Oqk22bRRsXfgpvxCOwGKZ439n9rEhNnzmmM+vYikS3hvEf5T2tXvCA+/yLHng9J6IAUlXY9g8Tk6LOhFJEbML0WDoclzUu2oSIGQmmKfBIr6zH5YuBFOb00N+D+ly6FldVevXxjLHtKyiGCEItXfeZNam5jWWzuKeJqkKBvb0WI=  ;
X-YMail-OSG: soJBOJwVM1m.8iX6JV5kgX0KRGqq.y9KyZ8O7zwmLCrR1105
Message-ID: <468082FF.6090704@yahoo.com.au>
Date: Tue, 26 Jun 2007 13:07:43 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/3] add the fsblock layer
References: <20070624014528.GA17609@wotan.suse.de>	<20070624014613.GB17609@wotan.suse.de>	<18046.63436.472085.535177@notabene.brown>	<467F71C6.6040204@yahoo.com.au>	<20070625122906.GB12446@think.oraclecorp.com>	<46807B32.6050302@yahoo.com.au> <18048.32372.40011.10896@notabene.brown>
In-Reply-To: <18048.32372.40011.10896@notabene.brown>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Tuesday June 26, nickpiggin@yahoo.com.au wrote:
> 
>>Chris Mason wrote:
>>
>>>The block device pagecache isn't special, and certainly isn't that much
>>>code.  I would suggest keeping it buffer head specific and making a
>>>second variant that does only fsblocks.  This is mostly to keep the
>>>semantics of PagePrivate sane, lets not fuzz the line.
>>
>>That would require a new inode and address_space for the fsblock
>>type blockdev pagecache, wouldn't it? I just can't think of a
>>better non-intrusive way of allowing a buffer_head filesystem and
>>an fsblock filesystem to live on the same blkdev together.
> 
> 
> I don't think they would ever try to.  Both filesystems would bd_claim
> the blkdev, and only one would win.

Hmm OK, I might have confused myself thinking about partitions...

> The issue is more of a filesystem sharing a blockdev with the
> block-special device (i.e. open("/dev/sda1"), read) isn't it?
> 
> If a filesystem wants to attach information to the blockdev pagecache
> that is different to what blockdev want to attach, then I think "Yes"
> - a new inode and address space is what it needs to create.
> 
> Then you get into consistency issues between the metadata and direct
> blockdevice access.  Do we care about those?

Yeah that issue is definitely a real one. The problem is not just
consistency, but "how do the block device aops even know that the
PG_private page they have has buffer heads or fsblocks", so it is
an oopsable condition rather than just a plain consistency issue
(consistency is already not guaranteed).

-- 
SUSE Labs, Novell Inc.

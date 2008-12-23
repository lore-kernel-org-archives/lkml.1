Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbYLWEkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbYLWEkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 23:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbYLWEkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 23:40:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:54908 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754514AbYLWEke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 23:40:34 -0500
Message-ID: <49506BBC.8040600@kernel.org>
Date: Tue, 23 Dec 2008 13:40:28 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: ide <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sata_sil: add Large Block Transfer support
References: <4945BDED.7050205@shaw.ca> <494F69C4.2060708@kernel.org> <49506AAF.3040400@shaw.ca>
In-Reply-To: <49506AAF.3040400@shaw.ca>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 23 Dec 2008 04:40:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Robert.

Robert Hancock wrote:
> Tejun Heo wrote:
>>
>> ioread/iowrite?
> 
> We know the register's always MMIO on this controller, so it's slightly
> more optimal to avoid the conditional in there.

Yeah, by a small margin but I think the consensus was to use
ioread/write no matter what if it's mapped using iomap.  I don't think
we guarantee iomapped address == mmio address after all.

>> I know it's not specific to this change but does mb() really make
>> sense here?  I don't think we need any barrier here.
> 
> Not sure. Documentation/memory-barriers.txt seems rather unfortunately
> vague on whether MMIO writes are strongly ordered with respect to memory
> writes. I seem to recall some debate on this a while ago, did it ever
> get resolved?

I remember that thread too but don't really any definite conclusion.
Eh... I hate barriers lying around without exact explanation.  :-(

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbXCUCwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbXCUCwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 22:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXCUCwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 22:52:49 -0400
Received: from terminus.zytor.com ([192.83.249.54]:59925 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbXCUCwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 22:52:47 -0400
Message-ID: <46009CEA.1050206@zytor.com>
Date: Tue, 20 Mar 2007 19:48:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: David Miller <davem@davemloft.net>, hch@infradead.org, arjan@infradead.org,
       zippel@linux-m68k.org, dmlb2000@gmail.com, linux-kernel@vger.kernel.org,
       gdb@sourceware.org
Subject: Re: PAGE_SIZE Availability Inconsistency
References: <20070308.134825.45514445.davem@davemloft.net> <20070309024324.GA24695@kryten> <45F0E014.8060907@zytor.com> <20070308.202718.68040662.davem@davemloft.net> <45F0E309.70403@zytor.com> <20070321021202.GA11745@kryten>
In-Reply-To: <20070321021202.GA11745@kryten>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Blanchard wrote:
> Hi,
> 
>> The advantage would be that it wouldn't require a v3 for platforms for 
>> which MIN_PAGE_SIZE == PAGE_SIZE, which accounts for a very large 
>> percentage of systems.
>>
>> You still have to look for the darn magic in two places, so there is no 
>> reason for it to be different.
> 
> The problem is if you can hit in two places then what PAGE_SIZE should
> you use to size the contents of the swap header while remaining backward
> compatible.
> 
> Im leaning towards Dave suggestion of creating a clean v3 swap header.
> 

Changing the header format doesn't make *ANY* difference whatsoever.

You have to write two copies of the swap header, and the kernel should 
check for a header at MIN_PAGE_SIZE first and then at PAGE_SIZE.

If there are fields (other than position) in the v2 swap header that are 
dependent on PAGE_SIZE, then the copy at MIN_PAGE_SIZE should be sized 
using MIN_PAGE_SIZE, and the copy at PAGE_SIZE should be sized at 
PAGE_SIZE.  It's that simple.

Creating a new format will not help that one iota, and will create 
gratuitous incompatiblity for the very common case of PAGE_SIZE == 
MIN_PAGE_SIZE.

	-hpa


	-hpa


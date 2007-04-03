Return-Path: <linux-kernel-owner+w=401wt.eu-S966118AbXDCTa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966118AbXDCTa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966119AbXDCTa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:30:59 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49644 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966118AbXDCTa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:30:58 -0400
Message-ID: <4612AB88.1000504@oracle.com>
Date: Tue, 03 Apr 2007 12:31:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: andi@firstfloor.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, sam@ravnborg.org
Subject: Re: [PATCH] make csum_partial obj-y
References: <20070403112604.129610b1.randy.dunlap@oracle.com>	<p731wj1z0or.fsf@bingen.suse.de>	<4612A66D.5090009@oracle.com> <20070403.122708.116354009.davem@davemloft.net>
In-Reply-To: <20070403.122708.116354009.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Tue, 03 Apr 2007 12:09:33 -0700
> 
>> How does the networking code work across multiple architectures?
> 
> This has been discussed before.
> 
> The csum_partial() result value is only well defined modulo 0xffff.
> 
> The networking does csum_fold() or similar on the results, and so the
> right thing always happens there.
> 
> The reiserfs case is the worst because even ignoring the differences
> in csum_partial() return values, it always feeds this into
> cpu_to_le32() which basically means that it is putting a cpu-endian
> dependent value onto disk.  csum_partial() returns a fixed-endian,
> not cpu endian, value.  So feeding it into cpu_to_anything() is
> quite wrong.

Thanks David and Andi.  I get it.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbXDCTIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbXDCTIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXDCTIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:08:11 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39694 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbXDCTIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:08:09 -0400
Message-ID: <4612A66D.5090009@oracle.com>
Date: Tue, 03 Apr 2007 12:09:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       sam@ravnborg.org, davem@davemloft.net
Subject: Re: [PATCH] make csum_partial obj-y
References: <20070403112604.129610b1.randy.dunlap@oracle.com> <p731wj1z0or.fsf@bingen.suse.de>
In-Reply-To: <p731wj1z0or.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Randy Dunlap <randy.dunlap@oracle.com> writes:
> 
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fixes kernel bugzilla #8242:
>>
>> Move csum_partial() from lib-y to obj-$(CONFIG_CSUM_PARTIAL)
>> so that modules can use it.
>>
>> CONFIG_BLK_DEV_MD (md/raid driver) needs csum_partial(),
>> even when CONFIG_NET=n and BLK_DEV_MD=m, so build it as an
>> object to force it being built and available.
>>
>> REISERFS with XATTR=y also needs csum_partial(), so that
>> is enforced here.
> 
> They are all broken because csum_partial gives different values
> on different architectures.   You're just extending that to
> possibly more subsystems.

So the ones that can be localized (BLK_DEV_MD and REISERFS)
should have their own versions?

How does the networking code work across multiple architectures?

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbXERVqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbXERVqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbXERVqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:46:09 -0400
Received: from ishtar.tlinx.org ([64.81.245.74]:41320 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbXERVqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:46:08 -0400
Message-ID: <464E1E9A.8060605@tlinx.org>
Date: Fri, 18 May 2007 14:46:02 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: building i386 requires s390: "driver/crypto/Kconfig" sourcing
 s390 arch
References: <464DFF5F.5010905@tlinx.org> <20070518141735.aae3921a.randy.dunlap@oracle.com>
In-Reply-To: <20070518141735.aae3921a.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Fri, 18 May 2007 12:32:47 -0700 Linda Walsh wrote:
>
>   
>> Seems there is an include of s390 based config in file
>> drivers/crypto/Kconfig: source "arch/s390/crypto/Kconfig"
>>
>> The line doesn't seem to be need for an i386 build (haven't
>> tried x86_64 though).
>>
>> I take it that this was a braino?
>>     
>
> Does it cause a problem?  If yes, what problem?
>   
----
    Yes.  My source tree has unrelated architectures removed,
as a result when building i386 or x86_64, the config tools try to
include files from the s390 architecture.  It isn't there. 
I'm building x86, why should I be including files from other
architectures.  It is hierarchically unclean.

    Perhaps the s390 device needs to be moved under the crypto with
the other crypto devices?   If the standard that other architectures are
using is to put their devices in the crypto directory, then one might
expect all crypto devices to be there.  Why should s390 stick out and
put its crypto device someplace under the s390 tree, forcing parts of the
s390 tree to be included when building other architectures? 
> It looks like someone thought that all Hardware crypto devices
> should be listed under the same menu heading.  Makes some sense.
>   
I thought the idea was the menu reflected the options available in
the specific parts/branches -- i.e. if you have the menu option in
the crypto tree, then the source code should be there as well.

I'm not sure how flexible the include system is, but can't it be
"not included" unless compiling for ARCH_s390?



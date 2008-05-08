Return-Path: <linux-kernel-owner+w=401wt.eu-S1762990AbYEHLPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762990AbYEHLPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 07:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbYEHLPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 07:15:36 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:37028 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbYEHLPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 07:15:35 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 May 2008 07:15:35 EDT
Message-ID: <4822DF3F.7050506@googlemail.com>
Date: Thu, 08 May 2008 13:08:47 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: hinko.kocevar@cetrtapot.si, linux-kernel@vger.kernel.org
Subject: Re: time stamped printks
References: <4822B919.5070707@cetrtapot.si> <20080508.020124.232275605.davem@davemloft.net>
In-Reply-To: <20080508.020124.232275605.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Hinko Kočevar <hinko.kocevar@cetrtapot.si>
> Date: Thu, 08 May 2008 10:26:01 +0200
> 
>> Hi all,
>>
>> I'm building latest GIT tree kernel for CRIS architecture. Right now I'm seeing 
>> some strange values with printk stamps - at the start they are initialized to 0, 
>> but quickly change to 42949372 - 0x028F5AFC.
>>
>> Any thoughts to where to look for fix?
> 
> Very early in the boot, the timestamp counter fetching infrastructure
> isn't setup yet.  So zero is reported for the timestamp.
> 
> So early on in the boot, it is often not even possible to setup
> such things yet.  Because infrastructure they need for probing
> etc. isn't even available yet.
> 
> This happens on basically every single Linux platform, there
> isn't really anything to fix.

For the early boot 0's it is normal but not for the following strange values :)

I got the same problem on my 64bit box with latest git head and bisected it down to 3e51f33fcc7f55e6df25d15b55ed10c8b4da84cd

http://lkml.org/lkml/2008/5/8/146


Regards,

Gabriel C

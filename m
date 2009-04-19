Return-Path: <linux-kernel-owner+w=401wt.eu-S1751520AbZDSX1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbZDSX1J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 19:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbZDSX0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 19:26:53 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:64179 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbZDSX0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 19:26:52 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Apr 2009 19:26:52 EDT
X-IronPort-AV: E=Sophos;i="4.40,213,1238976000"; 
   d="scan'208";a="34030070"
Message-ID: <49EBB0F7.3050606@cisco.com>
Date: Sun, 19 Apr 2009 16:17:11 -0700
From: David VomLehn <dvomlehn@cisco.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] Wait for console to become available, v2
References: <20090416190837.GA26734@cuplxvomd02.corp.sa.net> <874owlqcce.fsf@basil.nowhere.org> <49EB5008.1090000@cisco.com> <20090419163923.GS14687@one.firstfloor.org>
In-Reply-To: <20090419163923.GS14687@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: sj-dkim-1; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Sun, Apr 19, 2009 at 09:23:36AM -0700, David VomLehn wrote:
>> Andi Kleen wrote:
>>> VomLehn <dvomlehn@cisco.com> writes:
...
>>> Also a setting to panic in this case might be useful, normally a system
>>> without console is not very useful and needs to be rebooted anyways.
>> Umm, those of us in the embedded space have the, perhaps misguided, 
>> notion that our systems are quite useful without consoles...
> 
> That seems more like a special case that shouldn't be default?

I have to disagree. Panicing because you can't open /dev/console is 
likely to mean that you get no output at all and so no chance to see a 
message explaining why the open failed. If the open failure is all that 
happened, the rest of the system may very well come up normally. You 
would then be able to look at the kernel log and diagnose the issue.

In any case, the purpose of this patch is fix USB consoles to work as 
they did before parallelized startup. This involves addressing a race 
condition that, theoretically, always existed but which previously 
hadn't been a problem. Changing the behavior when init_post() can't open 
/dev/console seems out of scope.

> -Andi


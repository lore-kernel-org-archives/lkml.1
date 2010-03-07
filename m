Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab0CGQhx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 11:37:53 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:38810 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab0CGQhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 11:37:52 -0500
Message-ID: <4B93D63B.1040403@oracle.com>
Date: Sun, 07 Mar 2010 08:37:15 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>, don.mullis@gmail.com,
       david@fromorbit.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: modules, "modules" and CONFIG_LIST_SORT
References: <20100307091223.GA4895@x200> <alpine.LFD.2.00.1003070320370.4033@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003070320370.4033@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B93D645.0102:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/10 03:23, Linus Torvalds wrote:
> 
> 
> On Sun, 7 Mar 2010, Alexey Dobriyan wrote:
>>
>> Unpleasant side effect of the change is that some modules stop being
>> true modules, i. e. admin is unable to start using them without reboot
>> if kernel was compiled without that tiny amount of core kernel.
>>
>> Having used this feature several times, I think it'd be correct
>> to preserve this behaviour, at least not regress for those modules
>> which benefitted from it. For modules which were always "modules" (ipv6)
>> it's fine to continue.
>>
>> Can we declare some policy about it?
>>
>> And revert LIST_SORT commit if yes.
> 
> Yeah, I think that in cases like this, you have a very good argument: 
> LIST_SORT enables code that isn't that large, and is clearly very generic.
> 
> And changing the config later and trying to compile and install a module 
> is rather sane. And if that new module needs LIST_SORT, you're screwed 
> because it didn't get compiled in originally.
> 
> Honestly, personally I'd rather have a real library that modules can link 
> to _before_ even loading into kernel space, but that's not how we've 
> traditionally done things. So I guess we should just revert that commit.

xfs also needs "select LIST_SORT".  I posted a patch for that a few days
ago and now Christoph Hellwig has asked me to send the patch directly to Linus,
but if Linus is going to revert the 'config LIST_SORT' patch, I'll skip it.

-- 
~Randy

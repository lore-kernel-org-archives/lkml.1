Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbYHVUGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbYHVUGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYHVUGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:06:34 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:59005 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752874AbYHVUGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:06:33 -0400
Message-ID: <48AF1CE8.8020203@opengridcomputing.com>
Date: Fri, 22 Aug 2008 15:09:12 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: kxie@chelsio.com, netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, davem@davemloft.net, michaelc@cs.wisc.edu,
       rdreier@cisco.com, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, divy@chelsio.com, dm@chelsio.com, leedom@chelsio.com
Subject: Re: [PATCH 1/4 2.6.28] cxgb3 - manage a private ip address for iSCSI
References: <200808221838.m7MIcW6a004400@localhost.localdomain>	<20080822120851.c45a90f2.akpm@linux-foundation.org>	<48AF10BE.9050100@opengridcomputing.com> <20080822125316.37547cce.akpm@linux-foundation.org>
In-Reply-To: <20080822125316.37547cce.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 22 Aug 2008 14:17:18 -0500
> Steve Wise <swise@opengridcomputing.com> wrote:
>
>   
>> Andrew Morton wrote:
>>     
>>>> +	unsigned long octet;
>>>> +	const char *parse = buf;
>>>> +	char *endp;
>>>> +	int i;
>>>> +
>>>> +	for (i = 1; i <= 4; i++) {
>>>> +		octet = simple_strtoul(parse, &endp, 10);
>>>> +		if (endp == buf || octet > 255 ||
>>>> +		    (i < 4 && *endp != '.') ||
>>>> +		    (i == 4 && *endp != '\0' && *endp != '\n'))
>>>> +			return -EINVAL;
>>>> +		a = (a << 8) | octet;
>>>> +		parse = endp+1;
>>>> +	}
>>>> +	pi->iscsi_ipaddr = htonl(a);
>>>> +	return endp-buf;
>>>> +}
>>>>     
>>>>         
>>> This appears to be taking a dotted quad ipv4 address in ascii form,
>>> turning it into a u32 while performing checking?
>>>
>>> Surely we have a library function somewhere in networking which does
>>> this?  If not, I'd suggest writing one. 
>>>
>>>   
>>>       
>> try in_aton() from include/linux/inet.h.
>>
>>     
>
> yeah.  But that function is a crock.  No error checking at all!
>   

Oh you want error checking?

:)

Yea if this is a user/sysadmin supplied value, then we need a rubust 
inet_aton() in the kernel to validate it...



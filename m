Return-Path: <linux-kernel-owner+w=401wt.eu-S1765563AbYFKS4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765563AbYFKS4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759030AbYFKSsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:48:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:1696 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759000AbYFKSsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:48:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Xaij2nsyJK2PTAIj2hF60N1L8QLKFMGBjnlmJSy3rs93/vauDtKFZlKku2yHOS3cuc
         yQ3w7C4oWiXVl4l4L5XEff967z/1Oxq0hYbVblrkUrnpov0+WX9mtX43AY+e36hZaTWc
         aWG9Rb9pMDilqw4IK1FH0M9WLbTKXb3UXw7+Q=
Message-ID: <48501E1B.70703@gmail.com>
Date: Wed, 11 Jun 2008 20:48:59 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 2/4] Setup the memrlimit controller (v5)
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain> <20080521152948.15001.39361.sendpatchset@localhost.localdomain> <4850070F.6060305@gmail.com> <48500C66.7040807@linux.vnet.ibm.com>
In-Reply-To: <48500C66.7040807@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Andrea Righi wrote:
>> Balbir Singh wrote:
>>> +static int memrlimit_cgroup_write_strategy(char *buf, unsigned long
>>> long *tmp)
>>> +{
>>> +    *tmp = memparse(buf, &buf);
>>> +    if (*buf != '\0')
>>> +        return -EINVAL;
>>> +
>>> +    *tmp = PAGE_ALIGN(*tmp);
>>> +    return 0;
>>> +}
>> We shouldn't use PAGE_ALIGN() here, otherwise we limit the address space
>> to 4GB on 32-bit architectures (that could be reasonable, because this
>> is a per-cgroup limit and not per-process).
>>
> 
> You mean un-reasonable?

well... I mean, there would be no reason to apply this fix if it was a
limit per-task on 32-bit. ;-)

-Andrea

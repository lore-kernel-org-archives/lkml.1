Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbZFWLzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbZFWLzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759386AbZFWLzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:55:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44162 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757628AbZFWLz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:55:29 -0400
Message-ID: <4A40C2E7.9000705@redhat.com>
Date: Tue, 23 Jun 2009 14:56:23 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <gregory.haskins@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH RFC] pass write value to in_range pointers
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622151631.GA14780@redhat.com> <4A3FA6FC.9030301@novell.com> <20090622160833.GA15228@redhat.com> <4A3FB156.3030301@novell.com> <20090622172720.GC15228@redhat.com> <4A405436.1080100@gmail.com> <20090623114438.GD17635@redhat.com>
In-Reply-To: <20090623114438.GD17635@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2009 02:44 PM, Michael S. Tsirkin wrote:
> On Tue, Jun 23, 2009 at 12:04:06AM -0400, Gregory Haskins wrote:
>    
>>>>   It will also need to support
>>>> multiple matches.
>>>>
>>>>          
>>> What, signal many fds on the same address/value pair?
>>> I see this as a bug. Why is this a good thing to support?
>>> Just increases the chance of leaking this fd.
>>>
>>>        
>> I believe Avi asked for this feature specifically, so I will defer to him.
>>      
>
> Hmm. That's hard to implement in my model. Avi, can we give up
> this feature? I don't think anyone needs this specifically ...
>    

I think we can make do with passing that single eventfd to multiple 
consumers.  It means their event count reads may return zero, but I 
guess we can live with that.

I do want to retain flexibility in how we route events.

-- 
error compiling committee.c: too many arguments to function


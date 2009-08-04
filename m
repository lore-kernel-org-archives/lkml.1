Return-Path: <linux-kernel-owner+w=401wt.eu-S932735AbZHDJ1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735AbZHDJ1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 05:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbZHDJ1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 05:27:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40826 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240AbZHDJ1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 05:27:31 -0400
Date: Tue, 4 Aug 2009 12:26:21 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, davidel@xmailserver.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH-RFC 2/2] eventfd: EFD_STATE flag
Message-ID: <20090804092621.GB3185@redhat.com>
References: <20090803151426.GA3630@redhat.com> <4A770260.5000507@redhat.com> <20090803165708.GB3630@redhat.com> <4A77F6EF.8010002@redhat.com> <20090804085406.GA3311@redhat.com> <4A77FCB8.1000205@redhat.com> <20090804091755.GD4764@redhat.com> <4A77FE9D.3020505@redhat.com> <20090804092342.GE4764@redhat.com> <4A77FFB5.4060201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A77FFB5.4060201@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 12:30:29PM +0300, Avi Kivity wrote:
> On 08/04/2009 12:23 PM, Gleb Natapov wrote:
>> On Tue, Aug 04, 2009 at 12:25:49PM +0300, Avi Kivity wrote:
>>    
>>> On 08/04/2009 12:17 PM, Gleb Natapov wrote:
>>>      
>>>>> If a different read comes after the write but after our read, it will
>>>>> have transferred the value, resulting in the same situation.
>>>>>
>>>>> I think reads should never block with a state based mechanism.
>>>>>
>>>>>
>>>>>          
>>>> Reader may want to poll for the status change.
>>>>
>>>>        
>>> Without epoll(), it's inherently racy since reads from other processes
>>> can clear the status.
>>>
>>>      
>> This is correct for any file descriptor. Multiple readers shouldn't
>> simultaneously read from the same files descriptor if they expect to
>> make any sense from a result.
>>    
>
> I think counting eventfd is an exception, but in general you are right.

How is it an exception? It seems that one reader get the counter,
others will block until the next write.

> -- 
> error compiling committee.c: too many arguments to function

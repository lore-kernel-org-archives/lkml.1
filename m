Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538Ab0AXLGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab0AXLGl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 06:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421Ab0AXLGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 06:06:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab0AXLGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 06:06:39 -0500
Message-ID: <4B5C29BC.4050109@redhat.com>
Date: Sun, 24 Jan 2010 13:06:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Davide Libenzi <davidel@xmailserver.org>, mtosatti@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 1/3] eventfd: allow atomic read and waitqueue remove
References: <20100121162648.GA16458@redhat.com> <alpine.DEB.2.00.1001210857310.8548@makko.or.mcafeemobile.com> <4B588B29.2050100@redhat.com> <20100121172336.GA16707@redhat.com> <4B588FCE.7030803@redhat.com> <20100121173259.GC16707@redhat.com> <4B58933C.4090209@redhat.com> <20100121174538.GG16707@redhat.com> <4B589532.9070408@redhat.com> <4B589582.9030300@redhat.com> <20100121180250.GJ16707@redhat.com>
In-Reply-To: <20100121180250.GJ16707@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2010 08:02 PM, Michael S. Tsirkin wrote:
> On Thu, Jan 21, 2010 at 07:57:22PM +0200, Avi Kivity wrote:
>    
>> On 01/21/2010 07:56 PM, Avi Kivity wrote:
>>      
>>> On 01/21/2010 07:45 PM, Michael S. Tsirkin wrote:
>>>        
>>>>          
>>>>> But you're in process context.  An eventfd never blocks.
>>>>>            
>>>> Yes it blocks if counter is 0. And we don't know
>>>> it's not 0 unless we read :) catch-22.
>>>>          
>>> Ah yes, I forgot.
>>>
>>>        
>> Well, you can poll it and then read it... this introduces a new race (if
>> userspace does a read in parallel) but it's limited to kvm and buggy
>> userspace.
>>      
> I would rather not require that userspace never reads this fd.
> You are right that it does not now, but adding this as requirement
> looks like exporting an implementation bug to userspace.
>    

Well, I don't like risking 2.6.32 non-kvm users for a bug that doesn't 
happen in practice now.

After it gets some time in 2.6.33, we can backport it to 2.6.32 (since 
that will be maintained long term).

-- 
error compiling committee.c: too many arguments to function


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbZJRIYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbZJRIYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 04:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbZJRIYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 04:24:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbZJRIYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 04:24:18 -0400
Message-ID: <4ADAD070.5080002@redhat.com>
Date: Sun, 18 Oct 2009 17:23:12 +0900
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL RFC] pvclock cleanups and pvclock vsyscall support
References: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com> <4AD6C679.3000001@redhat.com> <4AD77C21.2050506@goop.org> <4ADAB8F4.6090502@redhat.com> <4ADACF48.9020907@goop.org>
In-Reply-To: <4ADACF48.9020907@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2009 05:18 PM, Jeremy Fitzhardinge wrote:
> On 10/18/09 15:43, Avi Kivity wrote:
>    
>> On 10/16/2009 04:46 AM, Jeremy Fitzhardinge wrote:
>>      
>>> Care to cook up a patch to implement the kvm bits to make sure it all
>>> works OK for you?
>>>
>>>        
>> I've started to do that, but it occurs to me that we're missing out on
>> NUMA placement by forcing all clocks to be on the same page. OTOH, if
>> the clocks are heavily used, they'll stay in cache, and if not, who
>> cares.
>>      
> Yes, I'd say so.  I'd expect the data to be very close to read-only, so
> the lines should be shared pretty efficiently.
>
>    

There wouldn't be any sharing since each clock is on its own cache 
line.  But the point is valid regardless.

> On the other hand, there's nothing to stop us from moving to multiple
> pages in future (either to support NUMA placement, or just more than 64
> cpus).
>    

I'm already allocating multiple pages, so we'd just need to adjust the 
fixmap.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


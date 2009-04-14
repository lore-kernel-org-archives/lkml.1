Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbZDNQNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbZDNQNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZDNQNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:13:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33090 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbZDNQNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:13:37 -0400
Message-ID: <49E4B654.6060101@redhat.com>
Date: Tue, 14 Apr 2009 19:14:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] deal with interrupt shadow state for emulated instruction
References: <1239653210-10422-1-git-send-email-glommer@redhat.com> <49E45894.7090700@redhat.com> <49E4B4D4.1020903@zytor.com>
In-Reply-To: <49E4B4D4.1020903@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Avi Kivity wrote:
>   
>> The comment about repeating 'mov ss' in the manual has that wonderful
>> word in it, May.  That means we're perfectly allowed to ignore it and
>> just set the flag unconditionally.
>>
>>     
>
> Realistically, though, this should only be done for a limited number of
> sequential instructions.
>
>   

Why?  Do you see a guest filling all of memory with 'mov ss' and 
expecting to break out of it via an interrupt?

>> I doubt we'll ever see a repeated 'mov ss', once is more than enough.
>>     
>
> True enough, except maliciously.
>   

Why do we care?  The guest can only harm itself, and if it wants to 
disable interrupts, it would be a lot easier for it to run a plain 'cli'.

I guess it would be a problem if we emulated 'mov ss' for ordinary 
userspace or vm86 mode, but we don't.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


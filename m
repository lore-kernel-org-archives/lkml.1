Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbYDJBIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbYDJBIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 21:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbYDJBIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 21:08:37 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34376 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbYDJBIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 21:08:36 -0400
Date: Wed, 9 Apr 2008 18:07:17 -0700
From: sukadev@us.ibm.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@osdl.org>, clg@fr.ibm.com, serue@us.ibm.com,
       "David C. Hansen" <haveblue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] clone64() and unshare64() system calls
Message-ID: <20080410010717.GA28477@us.ibm.com>
References: <20080409222611.GA28087@us.ibm.com> <47FD5899.2040206@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FD5899.2040206@zytor.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin [hpa@zytor.com] wrote:
> sukadev@us.ibm.com wrote:
>> This is a resend of the patch set Cedric had sent earlier. I ported
>> the patch set to 2.6.25-rc8-mm1 and tested on x86 and x86_64.
>> ---
>> We have run out of the 32 bits in clone_flags !
>> This patchset introduces 2 new system calls which support 64bit 
>> clone-flags.
>>      long sys_clone64(unsigned long flags_high, unsigned long flags_low,
>> 		unsigned long newsp);
>>      long sys_unshare64(unsigned long flags_high, unsigned long 
>> flags_low);
>> The current version of clone64() does not support CLONE_PARENT_SETTID and 
>> CLONE_CHILD_CLEARTID because we would exceed the 6 registers limit of some 
>> arches. It's possible to get around this limitation but we might not
>> need it as we already have clone()
>
> I really dislike this interface.
>
> If you're going to make it a 64-bit pass it in as a 64-bit number, instead 
> of breaking it into two numbers.

Maybe I am missing your point. The glibc interface could take a 64bit
parameter, but don't we need to pass 32-bit values into the system call 
on 32 bit systems ?

> Better yet, IMO, would be to pass a pointer to a structure like:
>
> struct shared {
> 	unsigned long nwords;
> 	unsigned long flags[];
> };
>
> ... which can be expanded indefinitely.

Yes, this was discussed before in the context of Pavel Emelyanov's patch

	http://lkml.org/lkml/2008/1/16/109

along with sys_indirect().  While there was no consensus, it looked like
adding a new system call was better than open ended interfaces.

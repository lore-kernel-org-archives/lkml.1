Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbXGIFeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbXGIFeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 01:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbXGIFd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 01:33:56 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:23220 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750989AbXGIFdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 01:33:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=mu+8IA6H1O6R5URSdesl/QIpkkqYXn8trgeroc4CixZ7X1drG+0UG1/pXtATzM6TzKhFsdsRipDXcMAe18hijLL58XFzcHHI6p2bOS1hMymTqgKaJ3Hhpnsnd6Ov9Yl8FQXTXBuGJRzWmXu+fbokjYNk8VF8/J7xe4mEaSBCVOY=  ;
X-YMail-OSG: mgzHIv0VM1k_GG7VmrnE2TJ51hUAXhqO8faxQcI_k7Kb3KdCfqASpM_R4IMUMAZpV2U_Dpo_RQ--
Message-ID: <4691C8BE.2050807@yahoo.com.au>
Date: Mon, 09 Jul 2007 15:33:50 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
CC: Jeremy Maitin-Shepard <jbms@cmu.edu>, Al Boldi <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com> <87tzsew712.fsf@jbms.ath.cx>	<4691B9A5.6060203@yahoo.com.au> <87k5taw5vc.fsf@jbms.ath.cx>	<4691BD6F.8000809@yahoo.com.au> <87fy3yw50p.fsf@jbms.ath.cx> <4691C08A.90707@yahoo.com.au>
In-Reply-To: <4691C08A.90707@yahoo.com.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Jeremy Maitin-Shepard wrote:
> 
>> Nick Piggin <nickpiggin@yahoo.com.au> writes:
> 
> 
>>> Yes, I have a rough idea about how page reclaim works. But I just
>>> mean it would not be trivial to load the new kernel into physically
>>> discontiguous memory. Possible of course, but I don't think kexec or
>>> the setup code could quite cope ATM.
>>
>>
>>
>> It would indeed be a pain for the new kernel to be loaded and have to
>> use discontiguous memory.  The trick is, though, that this is not
>> necessary.  Immediately before jumping to the new kernel, the first X
>> bytes (where X is the amount of memory the new kernel will get,
>> typically 16MB or 64MB) of physical memory are backed up into the
>> arbitrary discontiguous pages that are made available.  This will not
>> take very long, because copying even 64MB of memory is extremely fast.
>> Then the new kernel is free to use the first X bytes of contiguous
>> physical memory.  Problem solved.
> 
> 
> Ah, that sounds like it would be the right way to go. Good thinking.

Hmm, considering it is not a crash situation, it might even be
better again to simply reuse the exising kernel text and kernel
page table and memory map information if possible. That would
probably only require a meg or two to reinit drivers, load a
suspend-to-disk-init, and do the IO.

OTOH it would likely be more complex than just freeing up a bit
of memory and relocating it.

-- 
SUSE Labs, Novell Inc.

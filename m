Return-Path: <linux-kernel-owner+w=401wt.eu-S1762201AbXESKWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762201AbXESKWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 06:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbXESKWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 06:22:14 -0400
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2956 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbXESKWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 06:22:13 -0400
Message-ID: <464ECFD5.6090005@xs4all.nl>
Date: Sat, 19 May 2007 12:22:13 +0200
From: Hans de Bruin <bruinjm@xs4all.nl>
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <464BB252.8010008@cv-sv.de> <464CC8E1.5010407@cv-sv.de>
In-Reply-To: <464CC8E1.5010407@cv-sv.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Volkmann wrote:
> Christian wrote:
> Hmm, I really think so...:
>> May I brought up a wrong reason with the command cmpxchg64.
>> But disabling CONFIG_X86_CMPXCHG64 helps.
>>
> 
> 
> Hi,
> 
> 
> I found some time to investigate. My resume is:
> 
> - kernel/verify_cpu.S causes the stop at boot time
>   Cause the required flag for CMPXCHG8B is not set.
> 
> - boot/setup.S did not print "PANIC: CPU too old for this kernel"
>   ( not visible, also the message did not match )
> 
> - VIA C3_2: CMPXCHG8B should work always. Via C3 EBGA Datasheet R1.90 page 30 (3-4)
>   But the bit is not set cause of some early Win NT bugs.
> 
> - X86_CMPXCHG64 can be set and used. Just verify_cpu.S requires a change
>   to ignore the missing indicator at boot time.
> 
> 
> 
> My suggestion for the fix is:
> 
> - kernel/verify_cpu.S should be more tolerant if CONFIG_MVIAC3_2 is set
>   ( see patch below )
> 
> - boot/setup.S should be fixed to print out a proper error message
>   ( see below )
> 
> - X86_CMPXCHG64 patch(earlier mail in thread ) should not be used.
> 
> 
> - Important: somebody to check other CPU types if the same behavior happens.

I applied the patch on rc2, changed 'if CONFIG_MVIAC3_2' in if 
CONFIG_MVIAC7' and build a working VIA C7 kernel.

-- 
Hans

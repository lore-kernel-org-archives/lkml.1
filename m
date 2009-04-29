Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbZD2Xuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbZD2Xuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 19:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZD2Xuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 19:50:32 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:39563 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbZD2Xub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 19:50:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=o5OxF8YBcGkRefDuOt8ZC1WoMyacDTBWweGSZAHIV/634YYSALsHui0dv5Q3WBmVf6
         53OBmEQ59GyBIGa8mjP6n+BoWSchybVdwgQbmMpyWgGS1YYEU5mkdxR9asI4KBb9u1IZ
         w5GuemSsPFGV0DuN3IDBeL+cIt7PvpGLV5034=
Message-ID: <49F8E7C0.30207@gmail.com>
Date: Wed, 29 Apr 2009 17:50:24 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mao Yilu <ylmao@mail.ustc.edu.cn>
CC: linux-kernel@vger.kernel.org
Subject: Re: TSC unstable on Intel Pentium M processor 750
References: <440758024.12507@ustc.edu.cn>
In-Reply-To: <440758024.12507@ustc.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mao Yilu wrote:
> Hi,
> 
> I masked all the interrupts except keyboard interrupt before the instruction “hlt”, So the CPU ran nothing until I click the keyboard button. And I used “rdtscll” and “do_gettimeofday” to get the halt time. But the result of “do_gettimeofday” was longer than the one of “rdtscll” about 3s per minute. I don’t know why.
> I timed some math job using the same way in contrary to the “hlt” instruction. The TSC was not correct either. In 3 minutes, the result of “do_gettimeofday” was longer than the one of “rdtscll” about 5s.
> The processor is Intel Pentium M processor 750. From the software developer’s manual of Intel, the processor clock of Pentium M processors is impacted by Intel SpeedStep technology, while some other processors is not. Maybe this is another feature Pentium M processors own.
> Pentium M processors support 5 C-states. I am sure the TSC doesn’t stop in C0 and C1 states. But I am not sure about other states. Maybe other states will stop the clock, and “hlt” instruction will make the CPU into deeper state.
> These are my guess. I wanna the truth. Thank you.
> 
> Mao Yilu
> 

On many processors the TSC will stop in various C-states, and also the 
TSC frequency changes when CPU frequency changes. This is why using 
rdtsc in userspace is not reliable, since the code can't know whether or 
not TSC can be used on that CPU reliably or how to scale the results.

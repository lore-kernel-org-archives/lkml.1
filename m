Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZFGIaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZFGIaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 04:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbZFGI34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 04:29:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47065 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbZFGI3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 04:29:55 -0400
Message-ID: <4A2B7A79.4060600@redhat.com>
Date: Sun, 07 Jun 2009 11:29:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: guillaume.thouvenin@ext.bull.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6.30-rc8 KVM] gcc 3.3 dies at emulate_2op_cl().
References: <200906050539.n555dwAQ077095@www262.sakura.ne.jp>	<4A2B5D0E.20002@redhat.com> <200906071638.CIC52145.OFOQHLFSMOJVFt@I-love.SAKURA.ne.jp>
In-Reply-To: <200906071638.CIC52145.OFOQHLFSMOJVFt@I-love.SAKURA.ne.jp>
Content-Type: multipart/mixed;
 boundary="------------090206060803010109080101"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090206060803010109080101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Tetsuo Handa wrote:
> Avi Kivity wrote:
>   
>>> I think something is wrong with emulate_2op_cl() when compiled with gcc 3.3.5 .
>>>       
>> This is on i386, not x86_64, yes?
>>
>>     
> Yes. Building "make allmodconfig" using Debian Sarge on i686 machine.
>   

Does the attached patch help?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.


--------------090206060803010109080101
Content-Type: text/plain;
 name="fix-gcc3.3-register-pressure.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-gcc3.3-register-pressure.patch"

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 22c765d..01717a5 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -451,7 +451,7 @@ static u32 group2_table[] = {
 			_PRE_EFLAGS("0", "5", "2")				\
 			_op _suffix " %4,%1 \n"					\
 			_POST_EFLAGS("0", "5", "2")				\
-			: "=m" (_eflags), "+r" (_dstv), "=&r" (_tmp)		\
+			: "=m" (_eflags), "+rm" (_dstv), "=&r" (_tmp)		\
 			: "c" (_clv) , "r" (_srcv), "i" (EFLAGS_MASK)		\
 			); 							\
 										\

--------------090206060803010109080101--

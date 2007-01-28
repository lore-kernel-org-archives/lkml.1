Return-Path: <linux-kernel-owner+w=401wt.eu-S932509AbXA1JpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbXA1JpN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 04:45:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932507AbXA1JpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 04:45:13 -0500
Received: from il.qumranet.com ([62.219.232.206]:51270 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932509AbXA1JpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 04:45:11 -0500
Message-ID: <45BC70A5.7030707@qumranet.com>
Date: Sun, 28 Jan 2007 11:45:09 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: caglar@pardus.org.tr
CC: lkml <linux-kernel@vger.kernel.org>, kvm-devel@lists.sourceforge.net
Subject: Re: [PATCH] KVM: 'asm' operand has impossible constraints
References: <200701260140.47760.caglar@pardus.org.tr> <45BB15F1.6020600@qumranet.com> <200701272328.31532.caglar@pardus.org.tr>
In-Reply-To: <200701272328.31532.caglar@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

S.Çağlar Onur wrote:
> 27 Oca 2007 Cts tarihinde, Avi Kivity şunları yazmıştı: 
>   
>> The patch looks correct, but I don't understand the gcc error message.
>> Are we sure this isn't a gcc 4.2 bug?
>>
>> "g" appears to be equivalent to "rmi", if "i" is impossible, gcc is free
>> to use "r" or "m", no?
>>     
>
> Accorgind to GCC devs. its not a bug 
> (http://gcc.gnu.org/bugzilla/show_bug.cgi?id=29808), on comment #5 the 
> problem described like;
>
> "g" means "r"+"i" so the register allocator in the -O0 case is selecting "r" 
> while in the optimize case is selecting "i"
>
>   

That's a different bug. The gcc PR has an assembler error message, as 
expected, whereas the kvm miscompile has a compiler error, which I don't 
understand.

Anyhow, your patch is correct (because selecting "i" is indeed 
erroneous) so I'll apply it, but I'm worried that there's a gcc bug in 
there that we ought to report.


-- 
error compiling committee.c: too many arguments to function


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751143AbXH0WHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbXH0WHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbXH0WHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:07:16 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:31610 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbXH0WHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:07:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=KuavD9ypNyfSBBuL9fULkiKPb1VLRx3wpxd102EjUm5UZ7I8P1JwH8akt9weV8gL0W2S/KBc65fgcrBJ4UP0PjobtIAOjVJ1otYBCX76ir8tuFJTQpqJdL+KKmQw0LE0SoXycIDGECjLQE1hKdpsMg2gjU8+EzPu7KLnIwJyqOg=
Message-ID: <46D34B19.6050006@gmail.com>
Date: Tue, 28 Aug 2007 00:07:21 +0200
From: Luka Napotnik <luka.napotnik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: division and cpu usage
References: <46CE1BA2.8070200@gmail.com> <Pine.LNX.4.61.0708240731130.8096@chaos.analogic.com> <Pine.LNX.4.64.0708241442590.28540@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708241442590.28540@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt pravi:
> On Aug 24 2007 07:34, linux-os (Dick Johnson) wrote:
>>> I'm new to kernel development and have some questions.
>>>
>>> 1. Why can't I divide with regular casting to double ((double)a /
>>> (double)b)? It gives me strange errors when compiling:
>>>
>>> WARNING: "__divdf3" [/root....] undefined!
>>> WARNING: "__addf3" [/root/...] undefined!
>>> WARNING: "__floatsidf" [/root/...] undefined!
>>>
>>> And if I compile with normal integers, I get zero as the result.
>>>
>>> 2. I'm trying to get the percentage of CPU used for a certain
>>> task_struct and figured the following formula:
>>>
>>> (task->utime + task->stime) / jiffies

This formula just doesn't work. I have a task with 99% CPU (top) but the
result of that formula is random (4, sometimes 8). What am I doing
wrong? Please help.

>>>
>>> Before calculating I convert all the variables to jiffies. Is this correct?
> 
> * So use integer math: (task->utime + task->stime) * 100 / jiffies
>   and you get the 'common' percentage. In integer, that is.
> 
> * I am not sure about the use of jiffies when it comes to CONFIG_NO_HZ=y.
> 
>> Floating point operations are not allowed in the kernel. Often,
> 
> IIRC they are allowed since ... recently (2.6.16, .17? can't remember). When
> the kernel tries to execute an FP instruction (and traps as a result), more
> kernel code will enable that the FP stack gets properly switched when a process
> changes between userspace-kernelspace.
> 
>> You can use "long long" for high precision math if necessary.
> 
> That will give link failure for __udivdi3. Use do_div().
> 
> 
> 	Jan


Return-Path: <linux-kernel-owner+w=401wt.eu-S1764964AbXHXMrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764964AbXHXMrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760670AbXHXMq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:46:56 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52283 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761440AbXHXMqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:46:53 -0400
Date: Fri, 24 Aug 2007 14:46:52 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
cc: Luka Napotnik <luka.napotnik@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: division and cpu usage
In-Reply-To: <Pine.LNX.4.61.0708240731130.8096@chaos.analogic.com>
Message-ID: <Pine.LNX.4.64.0708241442590.28540@fbirervta.pbzchgretzou.qr>
References: <46CE1BA2.8070200@gmail.com> <Pine.LNX.4.61.0708240731130.8096@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 24 2007 07:34, linux-os (Dick Johnson) wrote:
>> I'm new to kernel development and have some questions.
>>
>> 1. Why can't I divide with regular casting to double ((double)a /
>> (double)b)? It gives me strange errors when compiling:
>>
>> WARNING: "__divdf3" [/root....] undefined!
>> WARNING: "__addf3" [/root/...] undefined!
>> WARNING: "__floatsidf" [/root/...] undefined!
>>
>> And if I compile with normal integers, I get zero as the result.
>>
>> 2. I'm trying to get the percentage of CPU used for a certain
>> task_struct and figured the following formula:
>>
>> (task->utime + task->stime) / jiffies
>>
>> Before calculating I convert all the variables to jiffies. Is this correct?

* So use integer math: (task->utime + task->stime) * 100 / jiffies
  and you get the 'common' percentage. In integer, that is.

* I am not sure about the use of jiffies when it comes to CONFIG_NO_HZ=y.

>Floating point operations are not allowed in the kernel. Often,

IIRC they are allowed since ... recently (2.6.16, .17? can't remember). When
the kernel tries to execute an FP instruction (and traps as a result), more
kernel code will enable that the FP stack gets properly switched when a process
changes between userspace-kernelspace.

>You can use "long long" for high precision math if necessary.

That will give link failure for __udivdi3. Use do_div().


	Jan
-- 

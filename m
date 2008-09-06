Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbYIFSYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbYIFSYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 14:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYIFSYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 14:24:42 -0400
Received: from japan.chezphil.org ([77.240.5.4]:5830 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbYIFSYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 14:24:41 -0400
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Date: Sat, 06 Sep 2008 19:24:39 +0100
Subject: Re: nice and hyperthreading on atom
Message-ID: <1220725479644@dmwebmail.dmwebmail.chezphil.org>
In-Reply-To: <20080906094248.5930911a@infradead.org>
References: <1220715811849@dmwebmail.dmwebmail.chezphil.org>
	<20080906094248.5930911a@infradead.org>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"
From: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven writes:
>> Phil Endecott wrote:
>> Dear Experts,
>>
>> I have an ASUS Eee with an Atom processor, which has hyperthreading 
>> enabled.  If I have two processes, one nice and the other normal, they 
>> each get 50% of the CPU time.  Of course this is what you'd expect if 
>> the scheduler didn't understand that the two virtual processors are not 
>> really independent.  I'd like to fix it.
>
> but you cannot imfluence the cpu's scheduling of the instructions.
> 
> As an OS one COULD decide to just not schedule the nice task at all,
> but then, especially on atom where HT has a high efficiency, your cpu
> is mostly idle ...

Here's how I imagine it: say I have one regular task and one "nice -9" 
task.  On a conventional uniprocessor system they would get about 90% 
and 10% of the CPU respectively.  On the hyperthreadng system they 
currently get equal shares; except that the CPU is more efficient with 
two threads running, so you could perhaps say that they get 60% each or 
something like that.  But 60% is still less than 90%, and I don't want 
my foreground interactive task being slowed down that much by this 
niced task.  So I envisage the system spending 20% of its time running 
both tasks and the remaining 80% of the time running just the 
higher-priority task.  That way, I get half of 20% = 10% spent on the 
nice task and half of 20% plus 80% = 90% spent on the foreground task.  
(Or maybe something like 12% + 92%, allowing for the hyperthreading efficiency.)

Here's a link to Con Kolivas' post where he described something like 
this back in 2004:

   http://thread.gmane.org/gmane.linux.kernel/178090/focus=178882


Phil.




Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbXDYBDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbXDYBDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 21:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbXDYBDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 21:03:41 -0400
Received: from tresys.irides.com ([216.250.243.126]:13314 "HELO
	exchange.columbia.tresys.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754566AbXDYBDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 21:03:40 -0400
Message-ID: <462EA8E9.6050700@tresys.com>
Date: Tue, 24 Apr 2007 21:03:37 -0400
From: Joshua Brindle <jbrindle@tresys.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Crispin Cowan <crispin@novell.com>
CC: David Wagner <daw-usenet@taverner.cs.berkeley.edu>,
       linux-kernel@vger.kernel.org,
       LSM ML <linux-security-module@vger.kernel.org>
Subject: Re: AppArmor FAQ
References: <20070417181016.GA10903@one.firstfloor.org> <Line.LNX.4.64.0704181620130.27545@d.namei> <f085og$3hg$1@taverner.cs.berkeley.edu> <1177004348.27654.139.camel@moss-spartans.epoch.ncsc.mil> <f08kg5$c88$1@taverner.cs.berkeley.edu> <462D5644.2090103@novell.com>
In-Reply-To: <462D5644.2090103@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Apr 2007 01:03:39.0663 (UTC) FILETIME=[8F79D1F0:01C786D5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Crispin Cowan wrote:
> David Wagner wrote:
>   
>> James Morris  wrote:
>>   
>>     
>>> [...] you can change the behavior of the application and then bypass 
>>> policy entirely by utilizing any mechanism other than direct filesystem 
>>> access: IPC, shared memory, Unix domain sockets, local IP networking, 
>>> remote networking etc.
>>>     
>>>       
>> [...]
>>   
>>     
>>> Just look at their code and their own description of AppArmor.
>>>     
>>>       
>> My gosh, you're right.  What the heck?  With all due respect to the
>> developers of AppArmor, I can't help thinking that that's pretty lame.
>> I think this raises substantial questions about the value of AppArmor.
>> What is the point of having a jail if it leaves gaping holes that
>> malicious code could use to escape?
>>
>> And why isn't this documented clearly, with the implications fully
>> explained?
>>
>> I would like to hear the AppArmor developers defend this design decision.
>>   
>>     
> It was a simplicity trade off at the time, when AppArmor was mostly
> aimed at servers, and there was no HAL or DBUS. Now it is definitely a
> limitation that we are addressing. We are working on a mediation system
> for what kind of IPC a confined process can do
> http://forge.novell.com/pipermail/apparmor-dev/2007-April/000503.html
>
>   
Also, things like:

    share_mem /usr/bin/firefox r,        # /bin/foo can share memory with /usr/bin/firefox for read only

clearly show that you aren't using native abstractions for IPC. The 
native abstraction for shared memory would be the key used when creating 
the shared memory segment. The same goes for message queues which are 
noticeably missing from the "simplified" IPC model.

This, of course, begs the question of whether you are using native 
abstractions for profiles at all, processes have nothing to do with the 
binary they started from after they've been started. The binary on disk 
could be something entirely different than the process from which it ran.

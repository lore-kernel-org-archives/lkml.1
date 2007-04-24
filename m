Return-Path: <linux-kernel-owner+w=401wt.eu-S1031027AbXDXCDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031027AbXDXCDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 22:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031024AbXDXCDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 22:03:17 -0400
Received: from tresys.irides.com ([216.250.243.126]:36999 "HELO
	exchange.columbia.tresys.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031006AbXDXCDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 22:03:16 -0400
Message-ID: <462D655E.2010302@tresys.com>
Date: Mon, 23 Apr 2007 22:03:10 -0400
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
X-OriginalArrivalTime: 24 Apr 2007 02:03:14.0940 (UTC) FILETIME=[B8180BC0:01C78614]
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
Except servers use IPC and need this access control as well. Without IPC 
and network restrictions you can't protect database servers, ldap 
servers, print servers, ssh agents, virus scanning servers, spam 
scanning servers, etc from attackers with knowledge of how to abuse the IPC.
> When our IPC mediation system is code instead of vapor, it will also
> appear here for review. Meanwhile, AppArmor does not make IPC security
> any worse, confined processes are still subject to the usual Linux IPC
> restrictions. AppArmor actually makes the IPC situation somewhat more
> secure than stock Linux, e.g. normal DBUS deployment can be controlled
> through file access permissions. But we are not claiming AppArmor to be
> an IPC security enhancement, yet.
>   
Without a security interface in DBUS similar to SELinux' apparmor won't 
be able to control who can talk to who across DBUS, only who can connect 
to DBUS directly.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1031012AbXDXA7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031012AbXDXA7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 20:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031011AbXDXA7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 20:59:05 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:53446 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031009AbXDXA7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 20:59:03 -0400
Message-ID: <462D5644.2090103@novell.com>
Date: Mon, 23 Apr 2007 17:58:44 -0700
From: Crispin Cowan <crispin@novell.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: David Wagner <daw-usenet@taverner.cs.berkeley.edu>
CC: linux-kernel@vger.kernel.org,
       LSM ML <linux-security-module@vger.kernel.org>
Subject: Re: AppArmor FAQ
References: <20070417181016.GA10903@one.firstfloor.org> <Line.LNX.4.64.0704181620130.27545@d.namei> <f085og$3hg$1@taverner.cs.berkeley.edu> <1177004348.27654.139.camel@moss-spartans.epoch.ncsc.mil> <f08kg5$c88$1@taverner.cs.berkeley.edu>
In-Reply-To: <f08kg5$c88$1@taverner.cs.berkeley.edu>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Wagner wrote:
> James Morris  wrote:
>   
>> [...] you can change the behavior of the application and then bypass 
>> policy entirely by utilizing any mechanism other than direct filesystem 
>> access: IPC, shared memory, Unix domain sockets, local IP networking, 
>> remote networking etc.
>>     
> [...]
>   
>> Just look at their code and their own description of AppArmor.
>>     
> My gosh, you're right.  What the heck?  With all due respect to the
> developers of AppArmor, I can't help thinking that that's pretty lame.
> I think this raises substantial questions about the value of AppArmor.
> What is the point of having a jail if it leaves gaping holes that
> malicious code could use to escape?
>
> And why isn't this documented clearly, with the implications fully
> explained?
>
> I would like to hear the AppArmor developers defend this design decision.
>   
It was a simplicity trade off at the time, when AppArmor was mostly
aimed at servers, and there was no HAL or DBUS. Now it is definitely a
limitation that we are addressing. We are working on a mediation system
for what kind of IPC a confined process can do
http://forge.novell.com/pipermail/apparmor-dev/2007-April/000503.html

When our IPC mediation system is code instead of vapor, it will also
appear here for review. Meanwhile, AppArmor does not make IPC security
any worse, confined processes are still subject to the usual Linux IPC
restrictions. AppArmor actually makes the IPC situation somewhat more
secure than stock Linux, e.g. normal DBUS deployment can be controlled
through file access permissions. But we are not claiming AppArmor to be
an IPC security enhancement, yet.

The proposed set of patches is a self-contained access control system
for file system access, and we would like it reviewed as such. Current
AppArmor docs are quite explicit that AppArmor only mediates file access
and POSIX.1e capabilities.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
Director of Software Engineering   http://novell.com


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbZKUO3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbZKUO3T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 09:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbZKUO3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 09:29:18 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:57427 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbZKUO3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 09:29:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qU8KfQC++ChZAdyc+fnGIHpJ7dsz2pLJwYkRbyewAk9NsSIBfyAuy2PpTlbl4uLPe6
         tqiEjgf7xJFTj7HiG6AZUQz4IHt2920c+oVHRyS6sy6fcq1bFJvZPbUKFsl7KN2uvfTt
         He53zQXjs2Hy1bGmkiA56LxaTezeO2WAzOwgs=
Message-ID: <4B07F93E.10502@gmail.com>
Date: Sat, 21 Nov 2009 08:29:18 -0600
From: Roger Heflin <rogerheflin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Faidon Liambotis <paravoid@debian.org>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, 557262@bugs.debian.org,
       Dave Chinner <david@fromorbit.com>, submit@bugs.debian.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       linux-raid@vger.kernel.org, asterisk-users@lists.digium.com,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: Bug#557262: 2.6.31+2.6.31.4: XFS - All I/O locks up to D-state
 after	24-48 hours (sysrq-t+w available) - root cause found = asterisk
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>	<alpine.DEB.2.00.0910181607040.27363@p34.internal.lan>	<20091019030456.GS9464@discord.disaster>	<alpine.DEB.2.00.0910190431180.23395@p34.internal.lan>	<20091020003358.GW9464@discord.disaster>	<alpine.DEB.2.00.0910200431290.21878@p34.internal.lan>	<alpine.DEB.2.00.0910210618210.10288@p34.internal.lan> <alpine.DEB.2.00.0911201530500.10757@p34.internal.lan> <4B0729D8.3000105@debian.org>
In-Reply-To: <4B0729D8.3000105@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Faidon Liambotis wrote:
> Justin Piszcz wrote:
>  > Found root cause-- root cause is asterisk PBX software.  I use an
> SPA3102.
>> When someone called me, they accidentally dropped the connection, I called
>> them back in a short period.  It is during this time (and the last time)
>> this happened that the box froze under multiple(!) kernels, always when
>> someone was calling.
> <snip>
>> I don't know what asterisk is doing but top did run before the crash
>> and asterisk was using 100% CPU and as I noted before all other processes
>> were in D-state.
>>
>> When this bug occurs, it freezes I/O to all devices and the only way to
>> recover
>> is to reboot the system.
> That's obviously *not* the root cause.
> 
> It's not normal for an application that isn't even privileged to hang
> all I/O and, subsequently everything on a system.
> 
> This is almost probably a kernel issue and asterisk just does something
> that triggers this bug.
> 
> Regards,
> Faidon


I had an application in 2.6.5 (SLES9)...that would hang XFS.

The underlying application was multi-threaded and both threads were 
doing full disks syncs every so often, and sometimes when doing the 
full disk sync the XFS subsystem would deadlock, it appeared to me tha 
one sync had a lock and was waiting for another, and the other process 
had the second lock and was waiting for the first...   We were able to 
disable the full disk sync from the application and the deadlock went 
away.   All non-xfs filesytems still worked and could still be 
accessed.    I did report the bug with some traces but I don't believe 
anyone ever determined where the underlying issues was.



Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbXH0Pey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbXH0Pey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 11:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbXH0Per
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:34:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:37575 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755812AbXH0Peq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:34:46 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX199agsiA+F9Xv1YWqIe5xTcvbgSKzj216f5yHBzfu
	87DrzMLRhztwuA
Message-ID: <46D2EEA2.6070501@gmx.net>
Date: Mon, 27 Aug 2007 17:32:50 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reset current->pdeath_signal on SUID binary execution
References: <1187380078.6698.448.camel@violet> <1187857271.15402.20.camel@violet>
In-Reply-To: <1187857271.15402.20.camel@violet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel,

>> the attached patch fixes a flaw in the "parent process death signal"
>> when executing SUID binaries. An unprivileged user may send arbitrary
>> signal to a child process even if it is running with higher privileges.
>>
>> The idea to fix this issue is to reset pdeath_signal not only on fork,
>> but also on the execution of a SUID binary.
>>
>> Michael, if we fix it this way, then the prctl() manual page should
>> reflect that behavior.
> 
> the patch has been merged into 2.4 and 2.6, so the manual page needs an
> update at some point.

I see your patch at:

http://article.gmane.org/gmane.linux.kernel/571635/match=pdeath%5fsignal+suid+binary+execution

But it's not clear to me in which 2.4.x and 2.6.x versions the change occurred (it isn't in 2.6.23-rc3 -- is it scheduled
for 2.6.23-rc4?).  Can you enlighten me?

Cheers,

Michael

>> From comments it seems that we have to also reset pdeath_signal inside
>> LSM when it comes to capability-raised executes, but I must admit that I
>> got lost there.
> 
> No further comments for this one? I am not familiar enough with it.
> 
> Regards
> 
> Marcel
> 
> 

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.

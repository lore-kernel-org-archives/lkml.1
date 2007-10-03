Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbXJCGwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbXJCGwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 02:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbXJCGwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 02:52:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:56146 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751834AbXJCGwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 02:52:45 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX19YBccVlhFYJdK8nzwm80EuDc036V3i3sC4yR/uWt
	LYw+OIcD/7bkwD
Message-ID: <47033BA1.7070901@gmx.net>
Date: Wed, 03 Oct 2007 08:50:09 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: rdunlap@xenotime.net, Andrew Morton <akpm@linux-foundation.org>,
       hch@lst.de, geoff@gclare.org.uk, tglx@linutronix.de, david@hardeman.nu,
       Ulrich Drepper <drepper@redhat.com>, subrata@linux.vnet.ibm.com,
       corbet@lwn.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Man page for revised timerfd API
References: <46FA0657.20700@gmx.net> <Pine.LNX.4.64.0709261038550.25778@alien.or.mcafeemobile.com> <20070927103531.184550@gmx.net> <Pine.LNX.4.64.0709270944300.763@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0709270944300.763@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Davide Libenzi wrote:
> On Thu, 27 Sep 2007, Michael Kerrisk wrote:
> 
>> Davide,
>>
>> A further question: what is the expected behavior in the
>> following scenario:
>>
>> 1. Create a timerfd and arm it.
>> 2. Wait until M timer expirations have occurred
>> 3. Modify the settings of the timer
>> 4. Wait for N further timer expirations have occurred
>> 5. read() from the timerfd
>>
>> Does the buffer returned by the read() contain the value
>> N or (M+N)?  In other words, should modifying the timer
>> settings reset the expiration count to zero?
> 
> Every timerfd_settime() zeroes the tick counter. So in your scenario it'll 
> return N.

Thanks Davide.

I modified the first para of the read description to make this clear:

       read(2)
              If the timer has already expired one or more times
              since   its  settings  were  last  modified  using
              timerfd_settime(), or since  the  last  successful
              read(2),  then the buffer given to read(2) returns
              an unsigned 8-byte integer  (uint64_t)  containing
              the number of expirations that have occurred.

(In the earlier version of the page the text talked about expirations
"since the timer was created".)

Cheers,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.


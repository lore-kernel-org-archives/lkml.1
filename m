Return-Path: <linux-kernel-owner+w=401wt.eu-S1760005AbXGWH50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005AbXGWH50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 03:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbXGWH5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 03:57:20 -0400
Received: from mail.gmx.net ([213.165.64.20]:50224 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750756AbXGWH5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 03:57:19 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX1+s/5V/oOCsX0jTfMEr2jIHBjSFKrgEKf3JuJmzcj
	VfTNPXfiiTPm7O
Message-ID: <46A46082.7030301@gmx.net>
Date: Mon, 23 Jul 2007 10:02:10 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
       Linux Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, drepper@redhat.com,
       stable@kernel.org
Subject: Re: Problems with timerfd()
References: <46A44B7D.3030700@gmx.net>	<20070722233826.20efa6e5.akpm@linux-foundation.org> <20070722234204.10d0f9a9.akpm@linux-foundation.org>
In-Reply-To: <20070722234204.10d0f9a9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:
> On Sun, 22 Jul 2007 23:38:26 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>>> Davide has already submitted a patch to you to make read() from a timerfd
>>> file descriptor return an 8 byte integer, and I understand it to have been
>>> accepted into -mm.
>> argh.  Nobody told me it was an ABI change!  We'll need to consider merging
>> make-timerfd-return-a-u64-and-fix-the-__put_user.patch into 2.6.22.x as
>> well.
>>
> 
> So I'm trying to write a halfway respectable description of that patch and
> I'm stuck when it comes to describing what will happen if someone tries
> to run a future timerfd-enabled glibc on 2.2.22 base.   In what manner
> will it misbehave?  What are the consequences of this decision?
> 

The difference would be that read() will only return 4 bytes, while the
application will expect 8.  If the application is checking the size of
returned value, as it should, then it will be able to detect the problem
(it could even be sophisticated enough to know that if this is a 4-byte
return, then it is running on an old 2.6.22 kernel).  If the application is
not checking the return from read(), then its 8-byte buffer will not be
filled -- the contents of the last 4 bytes will be undefined, so the u64
value as a whole will be junk.

Cheers,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.

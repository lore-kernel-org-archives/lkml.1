Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbXJAQWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbXJAQWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbXJAQW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:22:27 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:43539 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbXJAQW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:22:26 -0400
Date: Sun, 23 Sep 2007 01:37:44 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Michael Kerrisk <mtk.linux.lists@gmail.com>
Cc: Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>, geoff@gclare.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@xenotime.net>,
       vda.linux@googlemail.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, mtk-manpages@gmx.net
Subject: Re: RFC: A revised timerfd API
Message-ID: <20070922233744.GA2218@hardeman.nu>
Mail-Followup-To: Michael Kerrisk <mtk.linux.lists@gmail.com>,
	Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org,
	Ulrich Drepper <drepper@redhat.com>, geoff@gclare.org.uk,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Christoph Hellwig <hch@lst.de>, Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@xenotime.net>, vda.linux@googlemail.com,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>, mtk-manpages@gmx.net
References: <46F514C9.5010208@gmx.net> <E1IZ62P-0000EX-00@calista.eckenfels.net> <517f3f820709220907l4c4e693di3df6942bdca5bcfa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
In-Reply-To: <517f3f820709220907l4c4e693di3df6942bdca5bcfa@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 06:07:14PM +0200, Michael Kerrisk wrote:
>On 9/22/07, Bernd Eckenfels <ecki@lina.inka.de> wrote:
>> In article <46F514C9.5010208@gmx.net> you wrote:
>> >  1. This design stretches the POSIX timers API in strange
>> >     ways.
>>
>> Maybe it is possible to reimplement the POSIX API in usermode using the
>> kernel's FD implementation?
>
>It's a clever idea...  Without thinking on it too long, I'm not sure
>whether or not there might be some details which would make this
>difficult.

It seems to be a dangerous idea. It has the potential of breaking 
userspace applications that rely on POSIX timers not creating fd's.

Image code like this:

	/* Close stdin, stdout, stderr */
	close(0);
	close(1);
	close(2);

	/* Oh, a timer would be nice */
	timer_create(x, y, z);

	/* Create new stdin, stdout, stderr */
	fd = open("/dev/null", flags);
	dup(fd);
	dup(fd);

Unless timer_create does some magic to avoid using the lowest available 
fd, this would suddenly break as the timerfd would be fd 0.

-- 
David Härdeman

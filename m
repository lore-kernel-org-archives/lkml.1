Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbZKHRfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbZKHRfk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 12:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbZKHRfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 12:35:40 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51071 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbZKHRfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 12:35:39 -0500
Date: Sun, 8 Nov 2009 18:35:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Matteo Croce <technoboy85@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091108173537.GE1372@ucw.cz>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> <20091003072127.GC21407@elte.hu> <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The AMD Geode LX has an x86 id of 5 (i586) tought it's technically an i686:

It is not.


> root@alix:~# egrep '^(cpu family|model name|flags)' /proc/cpuinfo
> cpu family      : 5
> model name      : Geode(TM) Integrated Processor by AMD PCS
> flags           : fpu de pse tsc msr cx8 sep pge cmov clflush mmx
> mmxext 3dnowext 3dnow
> 
> indeed it has MMX, MMXEXT and CMOV, just lacks the long NOP instruction (NOPL).
> This patch adds a quirck to promote the Geode to an i686 and emulates
> the NOPL in the do_invalid_op trap, so the userspace never notices.
> Emulating the NOPL has minimum performance loss, emulating a NOPL
> takes 0.5 usecs
> and they are rarely used in x86

NOP should be fast, so this is bad idea.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbXE3Uqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbXE3Uqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbXE3Uqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:46:36 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409AbXE3Uqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:46:35 -0400
Date: Wed, 30 May 2007 13:44:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Ulrich Drepper <drepper@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
In-Reply-To: <465DDF0A.8080107@cosmosbay.com>
Message-ID: <alpine.LFD.0.98.0705301341480.26602@woody.linux-foundation.org>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org>
 <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com>
 <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com>
 <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org>
 <465DDF0A.8080107@cosmosbay.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-1113153342-1180557882=:26602"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-1113153342-1180557882=:26602
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT



On Wed, 30 May 2007, Eric Dumazet wrote:
> > 
> > No, Davide, the problem is that some applications depend on getting
> > _specific_ file descriptors.
> 
> Fix the application, and not adding kernel bloat ?

No. The application is _correct_. It's how file descriptors are defined to 
work. 

> Then you can also exclude multi-threading, since a thread (even not inside
> glibc) can also use socket()/pipe()/open()/whatever and take the zero file
> descriptor as well.

Totally different. That's an application internal issue. It does *not* 
mean that we can break existing standards.

> The only hardcoded thing in Unix is 0, 1 and 2 fds.

Wrong. I already gave an example of real code that just didn't bother to 
keep track of which fd's it had open, and closed them all. Partly, in 
fact, because you can't even _know_ which fd's you have open when somebody 
else just execve's you.

You can call it buggy, but the fact is, if you do, you're SIMPLY WRONG. 

You cannot just change years and years of coding practice, and standard 
documentations. The behaviour of file descriptors is a fact. Ignoring that 
fact because you don't like it is naïve and simply not realistic.

		Linus
---1463790079-1113153342-1180557882=:26602--

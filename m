Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbYFXBva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbYFXBva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 21:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbYFXBvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 21:51:22 -0400
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:23197 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752199AbYFXBvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 21:51:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FJ7+Y+w7ZNIQ5xUGJ9IICXdnoPzgb2Ds4VW/N67heK9i0ungUC3aD5qFdv45S9ag1Diy3ywIJ4q7tEli4N04WG5zsLPU+vMIIKS8HOpNFA5SSOKKSnpvz0b3Pb51JaVJjwCI8cHc+xALjqGcFdGzTricjWmOcjsELs/clrbit6Y=  ;
X-YMail-OSG: KyANFQQVM1mRARyDGHmw4ZAZZvFtXpR0lGIWZDHs7aqKPSlSvY7F9z_Pu0bRl26U74J7TWsGugAIAklis21Or5kvwLE0ET7kR1xRb5kKEQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #10815] 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Date: Tue, 24 Jun 2008 11:51:10 +1000
User-Agent: KMail/1.9.5
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Adrian Bunk <bunk@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
References: <20080615033001.GE26421@linux.vnet.ibm.com> <20080624005053.GA4827@martell.zuzino.mipt.ru> <alpine.LFD.1.10.0806231827330.2926@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806231827330.2926@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806241151.10775.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2008 11:31, Linus Torvalds wrote:
> On Tue, 24 Jun 2008, Alexey Dobriyan wrote:
> > Status update:
> > * bug is reproduced on another box with the very same symptoms:
> >   SMP=y, maxcpus=1 kernel occasionally fails, SMP=n is fine.
> >   Also Core 2 Duo, x86_64 [1]
> >
> >   Race is wide -- 60 seconds of rcutorture is enough.
>
> Very odd how you can reproduce it - now on two machines - but it doesn't
> seem to happen for others. You've tried different compilers, you've tried
> different config options, what the heck is left?

The PREEMPT_RCU thing? I've reproduced it. It hits lockless pagecache,
but I've also reproduced the same problem in dentry cache shrinking.
I'm sure it is a free-before-grace bug.

I've been using DEBUG_PAGEALLOC to make it easier to spot.

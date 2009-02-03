Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbZBCXId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbZBCXId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbZBCXIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:08:21 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:37279 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbZBCXIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:08:19 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 3 Feb 2009 15:08:16 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       andi@firstfloor.org, oleg@redhat.com, viro@ZenIV.linux.org.uk,
       David Miller <davem@davemloft.net>, hch@lst.de,
       linux-api@vger.kernel.org, mpm@selenic.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
In-Reply-To: <4988BD4E.8080206@cosmosbay.com>
Message-ID: <alpine.DEB.1.10.0902031446280.23050@alien.or.mcafeemobile.com>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net> <1233598811-6871-3-git-send-email-corbet@lwn.net> <20090203133942.2ecec281.akpm@linux-foundation.org> <4988BD4E.8080206@cosmosbay.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1795850513-865313531-1233701588=:23050"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1795850513-865313531-1233701588=:23050
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Tue, 3 Feb 2009, Eric Dumazet wrote:

> Andrew Morton a écrit :
> > On Mon,  2 Feb 2009 11:20:09 -0700
> > Jonathan Corbet <corbet@lwn.net> wrote:
> > 
> >> Matt Mackall suggested converting epoll's ep_lock to a bitlock as a way of
> >> saving space in struct file.  This patch makes that change.
> > 
> > hrm.  bit_spin_lock() makes people upset (large penguiny people).  iirc
> > it doesn't have all the correct/well-understood memory/compiler
> > ordering semantics which spinlocks have.  And lockdep doesn't know about
> > it.
> > 
> 
> In a previous attempt (2005), I suggested using a single global lock.
> 
> http://search.luky.org/linux-kernel.2005/msg50862.html
> 
> Probably an array of hashed spinlocks would be more than enough.

That could be done, although I'm not sure it's worth going that way to 
save 4 bytes. The effective saving rate is not even 4/sizeof(struct file) 
since struct file never comes alone, and when you allocate a struct file 
you always carry more allocations behind (at least for the cases where you 
tend to have a lot of them around, so size would matter).
The add/remove path in epoll is not a super-hot one, so it could be done. 
I dunno how this change matter with the patchset though.



- Davide
--1795850513-865313531-1233701588=:23050--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763812AbYBZTbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763812AbYBZTbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 14:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761831AbYBZTbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 14:31:24 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:41755 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761691AbYBZTbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 14:31:23 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 26 Feb 2008 11:31:21 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: Pierre Habouzit <madcoder@debian.org>, lkml <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Marc Lehmann <schmorp@schmorp.de>,
       David Schwartz <davids@webmaster.com>
Subject: Re: epoll and shared fd's
In-Reply-To: <cfd18e0f0802261114v4d4891bcy107bba2a181c1146@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802261125180.27243@alien.or.mcafeemobile.com>
References: <20080118134318.GD9607@artemis.madism.org> 
 <Pine.LNX.4.64.0801181257240.24685@alien.or.mcafeemobile.com> 
 <20080124084001.GB7356@artemis.madism.org> 
 <Pine.LNX.4.64.0801241556130.29058@alien.or.mcafeemobile.com> 
 <517f3f820801252337lcd4b0a0hde7359dc46a947dd@mail.gmail.com> 
 <Pine.LNX.4.64.0801261308270.10472@alien.or.mcafeemobile.com> 
 <47C42CB3.8040500@gmail.com>  <Pine.LNX.4.64.0802261054041.27243@alien.or.mcafeemobile.com>
 <cfd18e0f0802261114v4d4891bcy107bba2a181c1146@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Michael Kerrisk wrote:

> Okay -- I'll look at it some more.  I am however loathe to drop the
> term open file description, because POSIX uses, as well as a number of
> other Linux man pages by now.

Heh, POSIX. Now doesn't take a genius to see that "file description" and 
"file descriptor" looks amazingly similar, does it? :)


> > That'd mean placing an eventpoll custom hook into sys_close(). Looks 
> > very bad to me, and probably will look even worse to other kernel 
> > folks. Is not much a performance issue (a check to see if a file* is 
> > an eventpoll file is as easy as comparing the f_op pointer), but a 
> > design/style issue.
>
> Oh -- I wasn't suggesting we could make the change now -- it would
> break the ABI and all that.  I was just wondering why the decision
> wasn't made to do it the other way to begin with.  The existing
> semantics are somewhat couterintuitive, and potentially interact
> libraries that do private manipulations with file descriptors.

For the same reason that a custom hook in sys_close wouldn't have passed 
the radar ;)
As far as problems with libraries doing tricks with fds, that's an issue 
that goes beyond epoll.



- Davide



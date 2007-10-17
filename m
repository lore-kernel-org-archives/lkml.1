Return-Path: <linux-kernel-owner+w=401wt.eu-S1761225AbXJQWwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761225AbXJQWwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 18:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758832AbXJQWwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 18:52:35 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:50320 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726AbXJQWwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 18:52:34 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 17 Oct 2007 15:52:28 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: Michael Kerrisk <mtk-manpages@gmx.net>,
       lkml <linux-kernel@vger.kernel.org>,
       Subrata Modak <subrata@linux.vnet.ibm.com>, geoff@gclare.org.uk,
       Christoph Hellwig <hch@lst.de>
Subject: Re: Revised signalfd man-page
In-Reply-To: <4715A8A2.7020108@gmail.com>
Message-ID: <Pine.LNX.4.64.0710171549540.26718@alien.or.mcafeemobile.com>
References: <46FB9FB9.8080201@gmx.net> <Pine.LNX.4.64.0709271000420.763@alien.or.mcafeemobile.com>
 <47130EA1.6000300@gmail.com> <Pine.LNX.4.64.0710151103591.5204@alien.or.mcafeemobile.com>
 <4715A8A2.7020108@gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007, Michael Kerrisk wrote:

> > With the new code Linus already merged, signalfd does not attach to the 
> > sighand anymore, so the "orphaned sighand" behaviour is no more there.
> > An exec() will carry the fd over, and you will be able to use the fd in 
> > the same way you did before the exec(). If sigpending()/sigwaitinfo() will 
> > show signals available, so it should signalfd.
> 
> So I wrote:
> 
>    execve(2) semantics
>        Just  like  any  other  file  descriptor, a signalfd file
>        descriptor remains open across an  execve(2),  unless  it
>        has  been  marked  for close-on-exec (see fcntl(2)).  Any
>        signals  that  were  available  for  reading  before  the
>        execve(2)  remain  available to the newly loaded program.
>        (This is analogous to traditional signal semantics, where
>        a  blocked  signal that is pending remains pending across
>        an execve(2).)  (This is analogous to traditional  signal
>        semantics, where a blocked signal that is pending remains
>        pending across an execve(2).)
> 
> Okay?

Ok



> > It'll return the signals that would be normally returned to the thread 
> > with the standard signal delivery methods. That is, calling thread private 
> > signals, and calling thread-group shared signals.
> 
> So I wrote:
> 
>    Thread semantics
>        The semantics of signalfd file descriptors  in  a  multi-
>        threaded  program  mirror the standard semantics for sig-
>        nals.  In other words, when a thread reads  from  a  sig-
>        nalfd  file descriptor, it will read the signals that are
>        directed to the thread itself and the  signals  that  are
>        directed  to the process (i.e., the entire thread group).
>        (A thread will not be  able  to  read  signals  that  are
>        directed to other threads in the process.)
> 
> Okay?

Ok, although this looks more specific:

(A thread will not be able to read other threads private signals)



- Davide



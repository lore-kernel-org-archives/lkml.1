Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYHGTyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYHGTyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 15:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYHGTy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 15:54:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54650 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752580AbYHGTy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 15:54:27 -0400
Date: Thu, 7 Aug 2008 20:37:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Peterson <joe@skyrush.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tty: ctrl-c not always echoed, especially under load
Message-ID: <20080807203716.4a9870f6@lxorguk.ukuu.org.uk>
In-Reply-To: <489A06D9.1080600@skyrush.com>
References: <48977C96.2090005@skyrush.com>
	<20080805001129.72d06e60@lxorguk.ukuu.org.uk>
	<489A06D9.1080600@skyrush.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Aug 2008 14:17:29 -0600
Joe Peterson <joe@skyrush.com> wrote:

> Alan Cox wrote:
> > If the output buffer is full then echoed characters/^C etc will vanish the
> > way n_tty implements its buffering internally. It's always worked that
> > way.
> 
> One more observation:
> 
> In Linux, try this:
> 
> # cat > foo
> hi^Sthere^Q
> ^D
> 
> (in other words, during the cat into "foo", type "hi", hit ^S, then type
> "there", then hit ^Q, then, on the next line, ^D to end the file)
> 
> Note that the "there" does not appear after hitting ^Q, but it does
> appear in the file.  So the characters were accepted, but they were not
> echoed (not even saved for echo when the terminal is restarted).
> 
> This behavior differs from that of FreeBSD (just tried it for fun -
> haven't tried other Unix's yet).  I have noticed other times that the
> echo seems to get lost while the tty is stopped.  Not sure if all this
> is related, but something seems amiss.  Thoughts?

It should certainly occur if the output buffer is full but that shouldn't
be the case for a few bytes. Agreed the current behaviour is unexpected
and less than desirable so hack away.


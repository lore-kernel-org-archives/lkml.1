Return-Path: <linux-kernel-owner+w=401wt.eu-S1758965AbYJJNJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965AbYJJNJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 09:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbYJJNIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 09:08:55 -0400
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:34512 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754150AbYJJNIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 09:08:55 -0400
Date: Fri, 10 Oct 2008 15:19:31 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: mtk.manpages@gmail.com
cc: 7eggert@gmx.de, "H. Peter Anvin" <hpa@zytor.com>,
       Ulrich Drepper <drepper@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: dup2() vs dup3() inconsistency when
In-Reply-To: <cfd18e0f0810100459n13ae6fbfx53861f423114f4f7@mail.gmail.com>
Message-ID: <alpine.LSU.0.999.0810101514510.5758@be1.lrz>
References: <bl2EV-7G2-9@gated-at.bofh.it> <bl7v3-5sk-17@gated-at.bofh.it> 
 <blasN-OS-9@gated-at.bofh.it> <blaCu-Z0-11@gated-at.bofh.it> 
 <blaMj-18o-23@gated-at.bofh.it> <blaMj-18o-21@gated-at.bofh.it> 
 <bliqg-2DH-1@gated-at.bofh.it>  <E1KoGNo-0001bu-C2@be1.7eggert.dyndns.org>
 <cfd18e0f0810100459n13ae6fbfx53861f423114f4f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008, Michael Kerrisk wrote:
> On Fri, Oct 10, 2008 at 1:42 PM, Bodo Eggert <7eggert@gmx.de> wrote:
> > Michael Kerrisk <mtk.manpages@googlemail.com> wrote:
> >
> >> Well, as long as we are fixing the dup3() interface in the way that Al
> >> and Ulrich have suggested, what about another fix:
> >>
> >> give an error if newfd is already open, thus forcing the user to do an
> >> explicit close
> >>
> >> ?
> >>
> >> This silent close in dup2() is an implementation blemish.  Why not eliminate
> >> it?
> >
> > I think it might be usefull:
> > Thread B does some logging to fd 42
> > Thread A switches the logfile by creating a new file, writing a header and
> > then does dup3(fd, 42, O_WRONLY|O_APPEND|O_CLOEXEC); close(fd);
> 
> I don't know the details of the kernel locks here, so perhaps this is
> a naive question: but, as things stand is there not the potential for
> some nasty race if one thread is writing to fd 42 at the same time as
> another thread does a dup2(fd, 42)?

I strongly hope there would not be any ...

> > (Off cause this is not yet implemented, O_RDONLY would give some problems,
> >  O_CLOEXEC alone might be better done while open()ing the file, ... but you
> >  get the idea.)
> >
> >
> > BTW: I think dup3(fd, -1, flags) should use the file descriptor dup() would
> > return. Or should there be a dupf(fd, flags) syscall instead?
> 
> If one did this, maybe it would be better to have an extra flag that
> said: "use the first free file descriptor >= newfd", thus giving the
> more general functionality like fcntl(F_DUPFD).

I think you are right. I thought about something similar, too, but was 
distracted enough to not think about the connection.
-- 
Funny quotes:
10. Nothing is fool proof to a talented fool.

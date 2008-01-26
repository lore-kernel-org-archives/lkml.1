Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYAZHhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYAZHhw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 02:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYAZHho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 02:37:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:37491 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbYAZHhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 02:37:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=htOG08OBPuTswJoKFSitT6J4ZGjRY0cJEejnHRK+t6f4u4pHXdzFapjqfkyQTDm6dL+nXvnXK84ypRU8qpAlhmlGTxBgI2+FnZFFAnRtywJCoP4Cl8XijmEd6igaPJNLyR8hAp8xMrbtNY0AZ1YFjT6oZXTJMkRLaa6UmcukEzU=
Message-ID: <517f3f820801252337lcd4b0a0hde7359dc46a947dd@mail.gmail.com>
Date: Sat, 26 Jan 2008 08:37:41 +0100
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: epoll and shared fd's
Cc: "Pierre Habouzit" <madcoder@debian.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       mtk/manpages@gmail.com
In-Reply-To: <Pine.LNX.4.64.0801241556130.29058@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080118134318.GD9607@artemis.madism.org>
	 <Pine.LNX.4.64.0801181257240.24685@alien.or.mcafeemobile.com>
	 <20080124084001.GB7356@artemis.madism.org>
	 <Pine.LNX.4.64.0801241556130.29058@alien.or.mcafeemobile.com>
X-Google-Sender-Auth: 82b75787ffc61080
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 25, 2008 12:57 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
>
> On Thu, 24 Jan 2008, Pierre Habouzit wrote:
>
> > On Fri, Jan 18, 2008 at 09:10:18PM +0000, Davide Libenzi wrote:
> > > On Fri, 18 Jan 2008, Pierre Habouzit wrote:
> > >
> > > >   Hi,
> > > >
> > > >   I just came across a strange behavior of epoll that seems to
> > > > contradict the documentation. Here is what happens:
> > > >
> > > > * I have two processes P1 and P2, P1 accept()s connections, and send the
> > > >   resulting file descriptors to P2 through a unix socket.
> > > >
> > > > * P2 registers the received socket in his epollfd.
> > > >
> > > >   [time passes]
> > > >
> > > > * P2 is done with the socket and closes it
> > > >
> > > > * P2 gets events for the socket again !
> > > >
> > > >
> > > >   Though the documentation says that if a process closes a file
> > > > descriptor, it gets unregistered. And yes I'm sure that P2 doens't dup()
> > > > the file descriptor. Though (because of a bug) it was still open in
> > > > P1[0], hence the referenced socket still live at the kernel level.
> > > >
> > > >   Of course the userland workaround is to force the EPOLL_CTL_DEL before
> > > > the close, which I now do, but costs me a syscall where I wanted to
> > > > spare one :|
> > >
> > > For epoll, a close is when the kernel file* is released (that is, when all
> > > its instances are gone).
> > > We could put a special handling in filp_close(), but I don't think is a
> > > good idea, and we're better live with the current behaviour.
> >
> >   Okay, maybe updating the linux manpages to be more clear about that is
> > the way to go then. Thanks
>
> Sure. I'll send Michael Kerrisk and updated statement for the A6 answer in
> the epoll man page.

Thanks Davide -- yes please send me a patch.

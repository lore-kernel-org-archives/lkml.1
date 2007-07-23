Return-Path: <linux-kernel-owner+w=401wt.eu-S932271AbXGWUDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbXGWUDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbXGWUDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:03:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50968 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbXGWUDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:03:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Manfred Spraul <manfred@colorfullife.com>
Subject: Re: which signal is sent to freeze process?
Date: Mon, 23 Jul 2007 22:11:14 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, "Agarwal, Lomesh" <lomesh.agarwal@intel.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
References: <46A506F8.2020206@colorfullife.com>
In-Reply-To: <46A506F8.2020206@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707232211.15543.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 23 July 2007 21:52, Manfred Spraul wrote:
> Rafael wrote:
> > On Monday, 23 July 2007 20:38, Agarwal, Lomesh wrote:
> > > The other problem I am facing that read from socket returns with ENODATA
> > > when resuming. any ideas?
> >
> > It's of similar kind: the system call checks signal_pending(current) and exit
> > with an error if that's true.
> >
> > Well, I'm afraid we can't place try_to_freeze() in every system call that
> > does something like that ...
> >   
> I don't understand why the poll() system call returns to user space. 
> poll() uses ERESTARTNOHAND, thus it should not return to user space.
> Any ideas why ERESTARTNOHAND doesn't work?

Well, look at the code in fs/select.c:do_poll() .  If signal_pending(current)
is true, the main loop breaks and count is returned to do_sys_poll().  If
zero is returned and signal_pending(current) is still true, do_sys_poll()
returns -EINTR.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

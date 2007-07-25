Return-Path: <linux-kernel-owner+w=401wt.eu-S932336AbXGYTLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbXGYTLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbXGYTLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:11:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33054 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbXGYTLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:11:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Manfred Spraul <manfred@colorfullife.com>
Subject: Re: which signal is sent to freeze process?
Date: Wed, 25 Jul 2007 21:19:32 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       "Agarwal, Lomesh" <lomesh.agarwal@intel.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
References: <46A506F8.2020206@colorfullife.com> <46A50AF0.70305@colorfullife.com> <46A64984.1070808@colorfullife.com>
In-Reply-To: <46A64984.1070808@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707252119.33285.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 24 July 2007 20:48, Manfred Spraul wrote:
> > Hi!
> >
> > Can you generate small testcase that demonstrates the problem?
> >
> > > Then what would be the correct way to handle resume process. The other
> > > way of course is to make all the applications check the errno in case of
> > > failure. But that seems more more problematic then system call checking.
> > > What do you say?
> >
> > Hmm, does that testcase behave correctly over SIGSTOP/SIGCONT? I'm not
> > saying kernel behaves nicely here, but perhaps fixing the apps to
> > check errno properly is the right thing to do? :-)
> Perhaps the kernel should use ERESTARTNOHAND instead of EINTR?
> The current code is more than odd:
> - select() and sys_ppoll() both use ERESTARTNOHAND (i.e.: 
> the functions do not return to user space with SIGSTOP/SIGCONT or freezer())
> 
> - sys_poll() uses EINTR (i.e.: SIGSTOP/SIGCONT/freezer() return to user space)
> 
> Attached is a patch that switches sys_poll to ERESTARTNOHAND and a poll test app.
> Boot tested with FC6.
> 
> What do you think? With ERESTARTNOHAND, poll would only return to user space if the app has a SIGCONT handler installed.

Well, I don't know why sys_poll() uses EINTR, so I don't know if that's not for
a reason.  Using ERESTARTNOHAND instead of it seems to be a good idea, though.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

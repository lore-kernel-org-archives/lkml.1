Return-Path: <linux-kernel-owner+w=401wt.eu-S1423335AbXD3OyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423335AbXD3OyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423339AbXD3OyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:54:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41534 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423335AbXD3OyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:54:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: [linux-pm] Re: 2.6.21-rc7-mm2 suspend bug. [kernel/kthread.c]
Date: Mon, 30 Apr 2007 16:58:04 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       list <linux-pm@lists.linux-foundation.org>,
       Dan Kruchinin <dubalom@gmail.com>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, pm@smtp2.linux-foundation.org
References: <a8f16e2b0704291251l69c1b02ahb9b22370bc468fa1@mail.gmail.com> <20070430003946.b4d856b4.akpm@linux-foundation.org> <20070430100535.GA30975@in.ibm.com>
In-Reply-To: <20070430100535.GA30975@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704301658.05387.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 30 April 2007 12:05, Gautham R Shenoy wrote:
> On Mon, Apr 30, 2007 at 12:39:46AM -0700, Andrew Morton wrote:
> > On Sun, 29 Apr 2007 22:27:44 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > On Sunday, 29 April 2007 21:51, Dan Kruchinin wrote:
> > > > Hi all.
> > > > 
> > > > There is a problem on my macbook core duo with suspend.
> > > > after suspending when i'm trying to 'wake up' my notebook, it seems
> > > > that it works, but i don't see anything at my monitor. So i have to
> > > > reboot it to continue my work.
> > > 
> > > What exactly do you do to suspend?
> > > 
> > 
> > This is due to _cpu_down() calling kthread_bind() in state TASK_RUNNING.
> 
> The state should be TASK_INTERRUPTIBLE. That's the state of the thread
> 'p' should be in when we do a kthread_bind(p) in _cpu_down().
> 
> Are you sure about the TASK_RUNNING part ?

Well, the WARN_ON() in kernel/kthread.c, line166, is triggering here, so it
may be TASK_INTERRUPTIBLE too (should the WARN_ON() trigger in that case)?

Rafael

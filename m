Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbYDZNCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbYDZNCR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 09:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbYDZNCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 09:02:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42233 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbYDZNCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 09:02:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Cedric Le Goater <clg@fr.ibm.com>
Subject: Re: [RFC][PATCH 2/5] Container Freezer: Make refrigerator always available
Date: Sat, 26 Apr 2008 15:02:36 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, Matt Helsley <matthltc@us.ibm.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>, Oren Laadan <orenl@cs.columbia.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Linux Containers <containers@lists.linux-foundation.org>
References: <20080424064756.643890130@us.ibm.com> <20080425110456.GF14903@elf.ucw.cz> <4811C978.6010508@fr.ibm.com>
In-Reply-To: <4811C978.6010508@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804261502.37413.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 25 of April 2008, Cedric Le Goater wrote:
> Pavel Machek wrote:
> > Hi!
> > 
> >> Now that the TIF_FREEZE flag is available in all architectures,
> >> extract the refrigerator() and freeze_task() from kernel/power/process.c
> >> and make it available to all.
> >>
> >> The refrigerator() can now be used in a control group subsystem 
> >> implementing a control group freezer.
> >>
> >> Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
> >> Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> >> Tested-by: Matt Helsley <matthltc@us.ibm.com>
> > 
> > There's no problem with doing this... but you should get some debate
> > (with Linus?) whether using freezer for cgroups is sane. 
> 
> Yes that's what we are trying to know, is the fake signal mechanism 
> used by the freezer something we can build upon ? 

Well, currently, the freezer doesn't send fake signals to kernel threads which
turns out to be problematic, becase some kernel threads behave very much like
user space processes (basically, the threads related to NFS and CIFS).

I have an idea how to fix this issue, but I'm not sure if it's acceptable
overall.  I'll try to prepare a patch later today or tomorrow.

Thanks,
Rafael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbXEaG7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbXEaG7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 02:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbXEaG65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 02:58:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46640 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbXEaG64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 02:58:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: software suspend doesn't work with 2.6.22-rc3
Date: Thu, 31 May 2007 09:04:47 +0200
User-Agent: KMail/1.9.5
Cc: Maximilian Engelhardt <maxi@daemonizer.de>, nigel@nigel.suspend2.net,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200705261128.57332.maxi@daemonizer.de> <20070529003959.GA32543@gondor.apana.org.au> <200705310854.52490.rjw@sisk.pl>
In-Reply-To: <200705310854.52490.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705310904.47894.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 31 May 2007 08:54, Rafael J. Wysocki wrote:
> On Tuesday, 29 May 2007 02:39, Herbert Xu wrote:
> > On Mon, May 28, 2007 at 08:21:29PM +0200, Rafael J. Wysocki wrote:
> > >
> > > Well, it looks like we have to fix this one separately.
> > > 
> > > Can you please tell me what to do to make cryptd run?
> > 
> > If you build it as a module then just loading it should be sufficient.
> > If you have it built-in then it should always be there.
> > 
> > Let me know when you guys have a final patch.
> 
> The problem is more serious than I thought:
> 
> kthread_create() in crypto/cryptd.c line 302 doesn't return, so cryptd is stuck
> in TASK_UNINTERRUPTIBLE all the time and it doesn't even execute one
> instruction from cryptd_thread() [this happens on x86_64].

Sorry, I was wrong.

kthread_create() returns, but cryptd_thread() is not executed and the cryptd
process is stuck in TASK_UNINTERRUPTIBLE.

Greetings,
Rafael

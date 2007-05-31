Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbXEaGtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbXEaGtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 02:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbXEaGtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 02:49:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46599 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbXEaGtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 02:49:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: software suspend doesn't work with 2.6.22-rc3
Date: Thu, 31 May 2007 08:54:51 +0200
User-Agent: KMail/1.9.5
Cc: Maximilian Engelhardt <maxi@daemonizer.de>, nigel@nigel.suspend2.net,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200705261128.57332.maxi@daemonizer.de> <200705282021.30355.rjw@sisk.pl> <20070529003959.GA32543@gondor.apana.org.au>
In-Reply-To: <20070529003959.GA32543@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705310854.52490.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 29 May 2007 02:39, Herbert Xu wrote:
> On Mon, May 28, 2007 at 08:21:29PM +0200, Rafael J. Wysocki wrote:
> >
> > Well, it looks like we have to fix this one separately.
> > 
> > Can you please tell me what to do to make cryptd run?
> 
> If you build it as a module then just loading it should be sufficient.
> If you have it built-in then it should always be there.
> 
> Let me know when you guys have a final patch.

The problem is more serious than I thought:

kthread_create() in crypto/cryptd.c line 302 doesn't return, so cryptd is stuck
in TASK_UNINTERRUPTIBLE all the time and it doesn't even execute one
instruction from cryptd_thread() [this happens on x86_64].

I've investigated this for a while, but I don't know why it happens.

Greetings,
Rafael

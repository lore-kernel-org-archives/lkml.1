Return-Path: <linux-kernel-owner+w=401wt.eu-S1751851AbXA3Wbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbXA3Wbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbXA3Wbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:31:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40765 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbXA3Wbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:31:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.name>
Subject: Re: question on resume()
Date: Tue, 30 Jan 2007 23:32:25 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, nigel@nigel.suspend2.net,
       pm list <linux-pm@lists.osdl.org>
References: <200701291206.39637.oneukum@suse.de> <200701301732.56444.rjw@sisk.pl> <200701301750.48196.oliver@neukum.name>
In-Reply-To: <200701301750.48196.oliver@neukum.name>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701302332.26063.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Added linux-pm to the Cc list, because I'm going to talk about things that
I know only from reading the code.]

On Tuesday, 30 January 2007 17:50, Oliver Neukum wrote:
> Am Dienstag, 30. Januar 2007 17:32 schrieb Rafael J. Wysocki:
> > However, you can always inspect the PF_FROZEN flag of the tasks in question
> > if that's practicable.
> 
> What would I do with that information? Ignore completion of IO?

I probably should say "that depends", but that wouldn't be very helpful.

Getting back to your initial question, which is if wake_up() may be called
from a driver's .resume() routine, I think the answer is no, it may not,
because in that case the "notified" tasks would be removed from the wait
queue, but the refrigerator() would (wrongly) restore their states as
TASK_UNINTERRUPTIBLE (or TASK_INTERRUPTIBLE for wake_up_interruptible()).

Generally, you are safe if your driver only calls wake_up() from a process
context, but not from .resume() or .suspend() routines (or from an
unfreezeable kernel thread).

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King

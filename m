Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004Ab0ADTpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab0ADTpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 14:45:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737Ab0ADTpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 14:45:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55685 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab0ADTpG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 14:45:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Borkmann <danborkmann@googlemail.com>
Subject: Re: [suspend/resume] Re: userspace notification from module
Date: Mon, 4 Jan 2010 20:45:44 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: =?iso-8859-2?q?Bart=B3omiej_Zimo=F1?= <uzi18@o2.pl>,
       linux-kernel@vger.kernel.org, awalls@radix.net,
       linux-pm@lists.linux-foundation.org, stern@rowland.harvard.edu
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001040045.39517.rjw@sisk.pl> <4B41E318.4050809@gmail.com>
In-Reply-To: <4B41E318.4050809@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001042045.44372.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 January 2010, Daniel Borkmann wrote:
> Rafael J. Wysocki wrote:
> > On Monday 04 January 2010, Bart³omiej Zimoñ wrote:
> >> And what do You think about sending extra signals to processes?
> > 
> > I don't see a problem with this in principle, although I don't think signals
> > are very suitable for this particular purpose, because you need two-way
> > communication between the power manager and the processes it's going to
> > notify (because it has to wait for the processes to finish their preparations
> > and to tell it that they are ready).
> 
> Again, just to abandon some thoughts... do you really need that "two-way
> communication"? I mean if the kernel delivers that specific signal to
> the process/task_struct [do_signal():handle_signal()] it has to save the
> original execution context that will later on be restored after the
> non-default signal handling function returns. This is our ACK /
> notification for the successful return of the programs "suspend
> handler". The kernel module (if such exists) could be notified about
> that for instance by a simple notifier hook within kernelspace. I mean
> if I see this right, the "two-way" is just for the ACK isn't it?

_If_ the kernel sends the signals, which is not I think should be done.

Please keep that in the user space.  Really.

I don't see _any_ good reason for putting such things into the kernel.

Rafael

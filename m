Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbXL3Qud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbXL3Qud (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 11:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756025AbXL3Qu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 11:50:26 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:50046 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbXL3QuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 11:50:25 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC] sleepy linux
Date: Sun, 30 Dec 2007 17:39:42 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20071225230731.GA29030@elf.ucw.cz> <200712271041.30923.oliver@neukum.org> <20071229235134.GC17823@ucw.cz>
In-Reply-To: <20071229235134.GC17823@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712301739.42192.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 30. Dezember 2007 00:51:34 schrieb Pavel Machek:
> Hi!
> 
> > > ... I also don't need to call any suspend() routines, because all the
> > > drivers are already suspended, right?
> > 
> > Well, you have a number of devices which cannot do runtime pm.
> > They can do suspend/resume with the whole system. For them these
> > operations mean saving/restoring state.
> > So for these devices implementing autosuspend makes no sense.
> > They would sensibly do only idle/busy detection.
> 
> Yep... Let's call busy/idle detection and save/restore state
> "autosuspend" for those devices. It does not save any power, but it
> can be viewed as "kind-of-suspend". (No, I do not have this kind of
> details ready).

Well, you probably would have to walk through all devices and check
all devices are either suspended or can be suspended. That would mean
struct device has to be extended to show common attributes.

But what's wrong with calling suspend() the conventional way once you've
decided to go into sleepy mode?

[..]
> > We lack a notion of telling devices that they are opened only for
> > detecting wakeups. Currently a driver has to assume that an opened
> > device has to be fully functional.
> 
> Yes, we'll need to add some userland interfaces. No, this will not be
> easy.

This mainly means input devices.

	Regards
		Oliver

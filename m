Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbXL0KA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbXL0KA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 05:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbXL0KAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 05:00:21 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:49281 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbXL0KAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 05:00:21 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC] sleepy linux
Date: Thu, 27 Dec 2007 10:41:29 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20071225230731.GA29030@elf.ucw.cz> <200712262123.37152.oliver@neukum.org> <20071226203258.GE8094@elf.ucw.cz>
In-Reply-To: <20071226203258.GE8094@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712271041.30923.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 26. Dezember 2007 21:32:58 schrieb Pavel Machek:
 
> ... I also don't need to call any suspend() routines, because all the
> drivers are already suspended, right?

Well, you have a number of devices which cannot do runtime pm.
They can do suspend/resume with the whole system. For them these
operations mean saving/restoring state.
So for these devices implementing autosuspend makes no sense.
They would sensibly do only idle/busy detection.
 
> And yes, I want device activity to prevent s2ram. If user is burning
> CD, machine should not sleep. If user is actively typing, machine

In these cases the devices involved should report themselves busy,
shouldn't they?

> should not sleep. My vision is: screen saver tells kernel keyboard
> need not be very responsive, at that point keyboard driver can
> autosuspend the keyboard, and if that was the last device, whole
> system sleeps.

We lack a notion of telling devices that they are opened only for
detecting wakeups. Currently a driver has to assume that an opened
device has to be fully functional.

	Regards
		Oliver

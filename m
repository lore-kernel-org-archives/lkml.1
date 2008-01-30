Return-Path: <linux-kernel-owner+w=401wt.eu-S933616AbYA3VVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616AbYA3VVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765482AbYA3VNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:13:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48208 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758455AbYA3VN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:13:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: hibernate/suspend-to-disk: to turn power or not?
Date: Wed, 30 Jan 2008 22:11:10 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <47A0CD90.5080208@msgid.tls.msk.ru>
In-Reply-To: <47A0CD90.5080208@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801302211.10622.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 30 of January 2008, Michael Tokarev wrote:
> I'm trying to "glue" hibernation and UPS control
> together, and have a question.
> 
> When the system power comes off an UPS (Uninterruptable
> Power Supply I mean), it's probably a good idea to turn
> the UPS off when shutting the system down or hibernating.
> 
> Even with shutdown (not related to hibernating) there's
> an interesting twist: modern systems can remember the
> previous on/off status when the power gets cut and
> restores - BIOS-controlled option that allows the
> system to automatically start when the input power
> returns.  Now, when we shutting down a system, we
> need to turn the UPS *before* powering down the
> system but *after* the shutdown procedure has been
> completed.  This is done by replacing poweroff with
> halt, and ordering the UPS to turn itself off after
> a small delay (needed for the poweroff command to
> complete) - this way, system will be on but in a
> safe-to-powercut mode, and in order to turn it
> back on only the UPS has to be turned on.
> 
> But the question comes as how to control the UPS when
> we replace shutdown with hibernation.  Ideally I want
> to send some commands to the UPS after hibernation has
> been completed (since I don't know how much time it
> will require to hibernate), but before the machine
> will be turned off by the kernel.  Or at the very least,
> to be able to stop the kernel turning the machine off
> after hibernation process is complete - this way,
> I can order the UPS to turn the power off after some
> delay and hope hibernation process will finish when
> the UPS will finally cut the power (not all UPSes
> are able to do timely shutdown like this).
> 
> What's my way here?

If your box hibernates and resumes correctly in the shutdown mode (ie.
basically without ACPI assistance), you can use s2disk for hibernation and
modify it to switch off the UPS instead of powering off the box.

Greetings,
Rafael

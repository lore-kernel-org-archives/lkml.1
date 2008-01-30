Return-Path: <linux-kernel-owner+w=401wt.eu-S1765010AbYA3URy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765010AbYA3URy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932808AbYA3UMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:12:49 -0500
Received: from ppp-110-246.adsl.restena.lu ([158.64.110.246]:36239 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932797AbYA3UMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:12:46 -0500
From: Bruno =?iso-8859-1?q?Pr=E9mont?= <bonbons@linux-vserver.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: hibernate/suspend-to-disk: to turn power or not?
Date: Wed, 30 Jan 2008 21:12:41 +0100
User-Agent: KMail/1.9.7
References: <47A0CD90.5080208@msgid.tls.msk.ru>
In-Reply-To: <47A0CD90.5080208@msgid.tls.msk.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801302112.41446.bonbons@linux-vserver.org>
X-VirusProbe: ClamAV, clean
X-SpamProbe: GOOD 0.0054888 43b1bc962c1425d543b72c04cfa83dde
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2008 20:18:40 you wrote:
> I'm trying to "glue" hibernation and UPS control
> together, and have a question.
>
> When the system power comes off an UPS (Uninterruptable
> Power Supply I mean), it's probably a good idea to turn
> the UPS off when shutting the system down or hibernating.
This depends on how you can turn the UPS back on...
If pushing the button manually is not an issue or the UPS
can still be controlled remotely (e.g. via network) when
being off it doesn't matter.

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
All systems I've seen that provide such an option in the BIOS
list three possible actions on power-back:
- remain off
- go back to previous state
- boot

In your case it's possibly easier to choose the option to
always boot when power comes back.

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
Can you configure your UPS to poweroff when load on its output
drops below a given threshold? (I know that such a feature
exists on master-slave power outlets where all slave outlets
are powered only when the master outlet has a sufficient load)

Another path may be to dig into hibernate via kexec:
  http://kerneltrap.org/node/11756

> What's my way here?
>
> Thanks!
>
> /mjt
>
> P.S.  Surprisingly, there's NO software that works
> with UPSes and implements even the basic shutdown
> process completely (not even mentioning hibernation).
> Most common is just to turn the system off without
> touching the UPS.  Yes it will work (till the UPS
> will run out of battery), but how about servers which
> should be up-n-running, ie. which should restart
> automatically?..  Oh well.
Can't the UPS software trigger scripts or be controlled
using scripts?

Regards,
Bruno


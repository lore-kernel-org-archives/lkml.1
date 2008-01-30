Return-Path: <linux-kernel-owner+w=401wt.eu-S1763364AbYA3VgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763364AbYA3VgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbYA3VgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:36:10 -0500
Received: from crca.org.au ([67.207.131.56]:36400 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759537AbYA3VgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:36:09 -0500
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jan 2008 16:36:09 EST
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <47A0EB65.1020505@nigel.suspend2.net>
Date: Thu, 31 Jan 2008 08:25:57 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hibernate/suspend-to-disk: to turn power or not?
References: <47A0CD90.5080208@msgid.tls.msk.ru>
In-Reply-To: <47A0CD90.5080208@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Michael Tokarev wrote:
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

That should be doable. How is your UPS connected? Presumably, with some 
modifications to the appropriate driver, we could send the commands when 
we're ready to shutdown. It would probably be useful whether or not your 
hibernating (if not, sending the commands could always be made an option).

Regards,

Nigel


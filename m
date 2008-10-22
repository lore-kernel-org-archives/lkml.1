Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbYJVLe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbYJVLe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 07:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYJVLeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 07:34:20 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:29839 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbYJVLeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 07:34:19 -0400
X-Spam-Flag: NO
X-Spam-Score: -9.389
Message-ID: <48FF0FB7.5070706@tremplin-utc.net>
Date: Wed, 22 Oct 2008 13:34:15 +0200
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.17) Gecko/20080929 Mandriva/2.0.0.17-2mdv2009.0 (2009.0) Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       burman.yan@gmail.com, pau@eslack.org
Subject: Re: [PATCH] LIS3LV02Dx Accelerometer driver (take 4)
References: <48FA3368.1040605@tremplin-utc.net> <20081021083822.GG15782@atrey.karlin.mff.cuni.cz> <20081021114255.a7dabc2d.akpm@linux-foundation.org> <20081022102713.GA7843@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20081022102713.GA7843@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek schreef:
Hello,


> Ok, I guess you have better eyeballs. Yes, the locking was totaly
> broken (and disabled by initing semaphore to 1 by default).
To which value the semaphore should have been initialised? I can see
DECLARE_MUTEX(name) declared as:
	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)

(I'm still learning about the locking in the kernel. To me, it looks
like a maze, and I couldn't find one simple document detailing all the
mechanisms.)

> Sorry
> about that.
> 
> This strips some more code, turns semaphore into mutex, and should
> solve more problems.
> 
> I killed the "power down on timer" thingie. I guess we can reintroduce
> it when we get the basics right (and driver works just fine without
> that... I did not detect unusual slowness).
I inserted the timer thingie because I have a program on my laptop which
reads the position twice per second. Using the joystick interface uses
two much CPU (it's 20 Hz) and so it's using the sysfs interface.
However, turning on and off the device twice per second is rather costly
(especially due to the ACPI access). That's why I made it delayed... and
I'd like to keep it this way.

I'll send this evening a "delayed power down" based on workqueue. Within
the  work of a workqueue, it's not possible to use a mutex, right? Only
semaphores are allowed?

Eric

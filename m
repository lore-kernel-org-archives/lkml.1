Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZJKQAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZJKQAs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 12:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbZJKQAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 12:00:46 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:38557 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbZJKQAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 12:00:43 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz
Subject: Re: zaurus suspend saga: 2.6.32-rc3
References: <20091011090423.GB1414@ucw.cz>
From: Robert Jarzmik <robert.jarzmik@free.fr>
X-URL: http://belgarath.falguerolles.org/
Date: Sun, 11 Oct 2009 17:59:45 +0200
In-Reply-To: <20091011090423.GB1414@ucw.cz> (Pavel Machek's message of "Sun\, 11 Oct 2009 11\:04\:23 +0200")
Message-ID: <87skdpvs3y.fsf@free.fr>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> Hi!
>
> I'm using patch similar to this for debugging:
>
> ...and good news is that it blinks after pressing of power button.
>
> ...core > pm_test also works.
>
> I also verified that end of pxa_pm_enter() is reached (with similar
> blinking patch). End of corgi_pxa_pm_enter() seems to be reached, too.
>
> Any ideas what to try next?
> 								Pavel

For the Mitac MIO A701 board, with a similar problem, I had :
 - removed almost all drivers (except screen and USB for control)
 - realized that the culprit was amongst drivers (which resumed in a loop in
 that time, should be the same now)
 - added some way to find which one failed (in my case, I chose morse code
 through the buzzer to "speak" the device's name)
 - found out the driver faulty code
 - fixed it
 - retried, cheered.

As soon as you reach a resumed screen, it becomes easier :)

That's a very tedious and long fight, good luck.

Cheers

--
Robert

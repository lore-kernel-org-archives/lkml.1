Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbYFBBhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbYFBBhz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 21:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbYFBBht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 21:37:49 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:34691 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbYFBBhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 21:37:48 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jun 2008 21:37:48 EDT
Message-ID: <48434D57.6030801@skyrush.com>
Date: Sun, 01 Jun 2008 19:31:03 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: harald.dunkel@t-online.de, linux-kernel@vger.kernel.org
CC: Alan Cox <alan@redhat.com>
Subject: Re: 2.6.25.3: su gets stuck for root
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harold,

I just also discovered this problem independently, and when I tracked it
down to stty and googled for it, I found your post.  In my test case, it
seems to get stuck in stty as run from the user's .bashrc (i.e., "su
user", where the user's .bashrc has the stty command).  In my case, the
arguments to stty do not seem to matter (well, I've tried "-ixany" and
"echoctl" - same results).  Also, the problem is made more reliable if a
sleep is done before the stty.  E.g., here's my test .bashrc:

sleep 2
stty -ixany

Note that if run from the console or a tty, having the user logged in
already seems to avoid the hang, but doing it within an xterm shows the
hang.  Strange, since with my original [more complex] test case, it
seemed to require *not* running X (tty/console only).

Most recent kernels show the issue - the only one that doesn't is
2.6.25-git17.  I am running Gentoo.  It does happen in a recent 2.6.26
git (an rc4 git from a couple of days ago).

Doing "ps" while hung shows stty in the "T" state.  "killall -9 stty"
releases it.

					-Joe

P.S.  Please cc my address on reply.

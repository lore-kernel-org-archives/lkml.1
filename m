Return-Path: <linux-kernel-owner+w=401wt.eu-S1757071AbYFBFzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbYFBFzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 01:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYFBFzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 01:55:09 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:42167 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbYFBFzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 01:55:08 -0400
Message-ID: <48438B3A.8050106@skyrush.com>
Date: Sun, 01 Jun 2008 23:55:06 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Harald Dunkel <harald.dunkel@t-online.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@redhat.com>
Subject: Re: 2.6.25.3: su gets stuck for root
References: <48434D57.6030801@skyrush.com> <48438126.3080308@t-online.de> <20080602053256.GF5609@1wt.eu>
In-Reply-To: <20080602053256.GF5609@1wt.eu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> Guys, you should test if "kill -CONT $pid" wakes the process up.
> It might be possible that some obscure bug appeared in the tty
> code resulting in SIGTTOU sometimes being sent to the caller,
> although that seems rather strange :-/

Just tried this ("kill -CONT <pid>") - no luck.

BTW, it should be possible, I would think, for others to duplicate this
fairly easily.  Just:

1) make a user, "foo", with login shell set to /bin/bash
2) create a .bashrc in foo's home dir with contents:

sleep 2
stty -ixany

3) cp .bashrc .bash_profile  (only needed to test "su - foo" too)
4) become root
5) type "su foo" (or "su - foo")

Sometimes it takes a second try to get it to happen.  If the su hangs,
check to see if the stty process is in state "T".  Also, it may make a
difference if you are logged in already as foo or are using X.  I first
noticed this with no users logged in (except root) and no X running (but
I can reproduce with X/xterm as well using this simple test case).  It
seems timing is a factor, so it's worth trying various things.

					-Joe

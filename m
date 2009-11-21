Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbZKUXPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbZKUXPE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 18:15:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZKUXPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 18:15:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60062 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbZKUXPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 18:15:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Weird suspend/resume problem on HP nx6325 w/ openSUSE 11.2 w/ -rc8
Date: Sun, 22 Nov 2009 00:15:30 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       DRI <dri-devel@lists.sourceforge.net>, Dave Airlie <airlied@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911220015.30912.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm not really sure where this should be reported, but here it goes.

After installing openSUSE 11.2 on my testbed nx6325 I noticed that resume
(from suspend to RAM) stopped working on it.  Apparently, it hanged while
switching from the console back to X and the box remained completely
unresponsive after that (it didn't even react to the magic sysrq).  However,
it used to work just fine with -rc7 and openSUSE 11.1, so I figured the problem
was related to the new X driver, which is radeon module version 6.12.4 (xorg
server 1.6.5).

So, I started to investigate and found that after a suspend from a framebuffer
console, the resume had always worked.  However, when I switched from X to the
framebuffer console, suspended, resumed and switched back to X, the box hanged
immediately just like during resume after a suspend from under X.  [There also
were some problems when switching from X to the framebuffer console and back
which seemd to be independent of suspend/resume (in short, the screen stays
black after a switch from the framebuffer console to X and you need to kill X
to fix this).]

Later, however, I discovered that if the box was booted into runlevel 3, then
suspended to RAM and resumed, and then switched to runlevel 5, I could log
into X and suspend/resume without any problems for many times.  OTOH, after
booting directly into X, the first attempt to resume always resulted in a black
screen and a hard hang.

I wonder what's up in there.

[Hibernation/resume works 100% of the time AFAICS.]

Thanks,
Rafael

Return-Path: <linux-kernel-owner+w=401wt.eu-S934007AbXGTVJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934007AbXGTVJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758944AbXGTVIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:08:54 -0400
Received: from www17.your-server.de ([213.133.104.17]:51514 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758907AbXGTVIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:08:54 -0400
X-Greylist: delayed 2040 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jul 2007 17:08:53 EDT
Message-ID: <46A11B33.20002@m3y3r.de>
Date: Fri, 20 Jul 2007 22:29:39 +0200
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [Fwd:] New wake ups from sky2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-------- Original-Nachricht --------

Hi.

Today i did a git pull to be up to date again and i noticed in the
powertop tool that i'll get this new entry

  14,2% (  9,1)     <kernel core> : sky2_probe (sky2_idle)

with around 10 interrupts per second.

i think (i.e. i don't know and just guessing!) this commit is
responsible for these wake ups:

git show eb35cf60e462491249166182e3e755d3d5d91a28

Author: Stephen Hemminger <shemminger@osdl.org>
Date:   Tue Jun 13 17:17:31 2006 +0900

    [PATCH] sky2: stop/start hardware idle timer on suspend/resume

    The resume bug was caused not by an early interrupt but because the idle
    timeout was not being stopped on suspend.  Also disable hardware IRQ's
    on suspend.  Will need to revisit this with hotplug?

    Signed-off-by: Stephen Hemminger <shemminger@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

Any ideas?

mfg
thomas




Return-Path: <linux-kernel-owner+w=401wt.eu-S1751603AbYLUTSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbYLUTSV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 14:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbYLUTSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 14:18:13 -0500
Received: from fe02x03-cgp.akado.ru ([77.232.31.165]:50525 "EHLO akado.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750782AbYLUTSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 14:18:12 -0500
X-Greylist: delayed 3605 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Dec 2008 14:18:12 EST
Date: Sun, 21 Dec 2008 21:18:07 +0300 (MSK)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@linmac.oyster.ru
To: linux-kernel@vger.kernel.org
Subject: Lock-up on PPC64
Message-ID: <Pine.LNX.4.64.0812212058550.2164@linmac.oyster.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Synopsis

Plain/non-root userspace application which doesn't interface with
any weird out-of/in-tree drivers manages to lock-up a PS3 machine
running Linux.

The application in question is Mono VM running mcs.exe (C# compiler)
which tries to compile particular file, distribution is Yellow Dog Linux
6.0 with either stock (2.6.23.x) or custom compiled (2.6.27) 64bit kernel.


Symptoms are as follows (interaction is done via ssh from another
machine):

$ make
... lots of stdout/err messages
... eventually an error message

Eventually the ssh session terminates, PS3 is still pingable but
impossible to connect to, attaching keyboard and trying magic SysRq
doesn't work, typing keys into login: prompt works (as in - the terminal
shows keys that were pressed, but after hittiing enter the carret is
advanced and nothing happens, hitting random keys doesn't yield anything
either)

There's a bug in Mono bugzilla which describes exactly the same problem,
but it appears as if reporters machine continued working after hitting
the problem. https://bugzilla.novell.com/show_bug.cgi?id=414845
The reporter aslo managed to create minimal reproducible test case
(so that running `MONO_PATH=... .../mono .../mcs.exe prob.cs' kills
  this PS3 just as well)

Any pointers to what can be done to further debug this would be greatly
appreciated.

-- 
mailto:av1474@comtv.ru

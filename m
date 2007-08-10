Return-Path: <linux-kernel-owner+w=401wt.eu-S933414AbXHJJOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414AbXHJJOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 05:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757373AbXHJJOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 05:14:10 -0400
Received: from server009.webpack.hosteurope.de ([80.237.130.17]:37772 "EHLO
	server009.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754678AbXHJJOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 05:14:09 -0400
X-Greylist: delayed 1683 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Aug 2007 05:14:09 EDT
From: Daniel Exner <dex@dragonslave.de>
Reply-To: webmaster@dragonslave.de
To: linux-kernel@vger.kernel.org
Subject: EHCI Regression in 2.6.23-rc2
Date: Fri, 10 Aug 2007 10:45:57 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708101045.57166.dex@dragonslave.de>
X-bounce-key: webpack.hosteurope.de;dex@dragonslave.de;1186737249;bdcca566;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Please CC me, as I'm currently not subscribed to this list, thx.

After some serious hangs with 2.6.23-rc2 I did some bisects and this was the 
result:

196705c9bbc03540429b0f7cf9ee35c2f928a534 is first bad commit
commit 196705c9bbc03540429b0f7cf9ee35c2f928a534
Author: Stuart_Hayes@Dell.com <Stuart_Hayes@Dell.com>
Date:   Thu May 3 08:58:49 2007 -0700

    USB: EHCI cpufreq fix

    EHCI controllers that don't cache enough microframes can get MMF errors
    when CPU frequency changes occur between the start and completion of
    split interrupt transactions, due to delays in reading main memory
    (caused by CPU cache snoop delays).

    This patch adds a cpufreq notifier to the EHCI driver that will
    inactivate split interrupt transactions during frequency transitions.
    It was tested on Intel ICH7 and Serverworks/Broadcom HT1000 EHCI
    controllers.

    Signed-off-by: Stuart Hayes <stuart_hayes@dell.com>
    Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 0e6d518de17cf18155c7529f7b044a4660ca24e9 
736bbcc7d3fb138138ee1840d8a6b83b959c07fc M      drivers

As expected my system only hangs when cpufreq, powernow-k8 and ehci modules 
are loaded, and some transition should occur.
(Simulated by using userspace governour and changing freq manually)

The corresponding EHCI Controller is:

00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86) (prog-if 20
[EHCI])
        Subsystem: ASUSTeK Computer Inc. A7V600/K8V-X/A8V Deluxe motherboard

I could not get my hands on any output while the hang occurs, seems like the 
CPU is really bad locked.

Greetings
Daniel Exner

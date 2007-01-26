Return-Path: <linux-kernel-owner+w=401wt.eu-S965571AbXAZPym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965571AbXAZPym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 10:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965695AbXAZPym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 10:54:42 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:41126 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965571AbXAZPyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 10:54:41 -0500
Message-ID: <45BA2437.4000803@drzeus.cx>
Date: Fri, 26 Jan 2007 16:54:31 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: Petr Vandrovec <vandrove@vc.cvut.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: ncpfs and TCP vs UDP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Petr,

I was hoping you could give me some input on another concern I have.
Which of TCP and UDP is the preferred transport for NCP? The client for
Windows seems to use TCP, which would suggest that that is the most
tested dialect. I also did a quick test with bonnie++:

UDP:

Version  1.03 -----Sequential Output------ --Sequential Input- --Random-
             -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
        500M  1569  19  1714  10   826   9  1414  18  1569   9  65.2   3
             ------Sequential Create------ --------Random Create--------
             -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
       files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
          16   460  14   897  16   556  15   491  15  1131  13   320   6
poseidon.drzeus.cx,500M,1569,19,1714,10,826,9,1414,18,1569,9,65.2,3,16,460,14,897,16,556,15,491,15,1131,13,320,6

TCP:

Version  1.03 -----Sequential Output------ --Sequential Input- --Random-
             -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
        500M  1653  19  3711  11  2312   9  1419  18  4489   6  91.5   1
             ------Sequential Create------ --------Random Create--------
             -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
       files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
          16   483  14   912  15   587  14   483  14  1176  13   287   6
poseidon.drzeus.cx,500M,1653,19,3711,11,2312,9,1419,18,4489,6,91.5,1,16,483,14,912,15,587,14,483,14,1176,13,287,6

TCP has roughly twice the throughput of UDP. Note that this was done
against a vmware machine that wasn't exactly maxing out the network.

Input welcome.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

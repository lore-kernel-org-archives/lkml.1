Return-Path: <linux-kernel-owner+w=401wt.eu-S1760216AbYETCsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216AbYETCsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 22:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbYETCrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 22:47:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:51576 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbYETCrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 22:47:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=iH+7gp/c+cs9PhqkzKYLJLxTH4sK+Zksr7+8ymSMUMAn5HWsi/qmV06ih651i+xwlrLojacktRSES00TO9mhPOKioviZe6hp/c3n8CVe7BLj9VsYINs8zetaQIA5kOzNxtopfqisfiiAFzFf0Lzl9swHEQ0Eq1kGJbTeZR25e3I=
Message-ID: <3b279e3f0805191947i150ea675pc411adecef6a3446@mail.gmail.com>
Date: Mon, 19 May 2008 19:47:52 -0700
From: "Reeve Yang" <reeve.yang@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel 2.6.22 CPU shoot up with same amount of file I/O
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

We recently upgrade kernel from 2.6.17.4 to 2.6.22.15 on our products.
In our some test, the disk I/O shot as well as CPU utilization, which
starving our some other critical process. For the sake of curiosity, I
ran bonnie++ on both kernels, following are the result:

## ###############Linux 2.6.17 #1 SMP Tue May 6
##################################

Version 1.03c       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size       K/sec %CP K/sec %CP K/sec %CP K/sec %CP
K/sec %CP  /sec %CP
ib-10-34-68-2 2016M 23989  35 44123   6 16360   1 21823  28 43090   1 172.7   0
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16 +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++
ib-10-34-68-2.infoblox.com,2016M,23989,35,44123,6,16360,1,21823,28,43090,1,172.7,0,16,+++++,+++,+++++,+++,+++++,+++,+++++,+++,+++++,+++,+++++,+++


## ###############Linux 2.6.22.15 #1 SMP Tue May 6
##################################

bonnie++ -d /storage -s 2016M -u root
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size       K/sec %CP K/sec %CP K/sec %CP K/sec %CP
K/sec %CP  /sec %CP
ib-10-34-68-2 2016M 26078  94 52117  17 23596   5 27172  86 56402   4 160.2   0
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16 +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++
ib-10-34-68-2.infoblox.com,2016M,26078,94,52117,17,23596,5,27172,86,56402,4,160.2,0,16,+++++,+++,+++++,+++,+++++,+++,+++++,+++,+++++,+++,+++++,+++
###################################################################################

As you can see, the I/O throughput improves about 10%, but CPU
utilization is up to 94% from 35% in new and old kernel respectively
for the exact the same test on the exact same hardware system. My
mother board is Tyan S5102 and the CPU is IPentium(R) 4 CPU 3.40GHz. I
searched on the web, some guys suggest to use "highres=off nohz=off
clocksource=acpi-pm" etc., but no help. Has anyone here had similar
problem on  your system? Is this a problem/bug on 2.6.22 kernel?

I saw a patch from Fengguang Wu on this
board(http://lkml.org/lkml/2008/1/15/132). Is this the patch targeting
the above issue? I'd appreciate if anyone could help me out.

Thanks.
- Reeve

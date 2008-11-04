Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbYKDSeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbYKDSeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYKDSeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:34:09 -0500
Received: from [74.13.241.36] ([74.13.241.36]:33511 "EHLO slyph.dragoninc.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbYKDSeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:34:08 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Nov 2008 13:34:08 EST
From: "Doug Nazar" <nazard@dragoninc.ca>
To: "'J. Bruce Fields'" <bfields@citi.umich.edu>
Cc: "'David Woodhouse'" <David.Woodhouse@intel.com>,
       "'Al Viro'" <viro@zeniv.linux.org.uk>, <linux-kernel@vger.kernel.org>
Subject: 2.6.28-rc3 truncates nfsd results
Date: Tue, 4 Nov 2008 13:27:23 -0500
Message-ID: <000301c93eaa$fae98460$f0bc8d20$@ca>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ack+qqtybXi0WLWcQAqVIbuCgATOvA==
Content-Language: en-ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8d7c4203 "nfsd: fix failure to set eof in readdir in some situations"
breaks the nfsd server. Bisected it back to this commit and reverting it
fixes the problem.

However, it only happens on certain machines even with the same kernel &
filesystem (ext3). I've two groups of similar computers, each group running
identical kernels. The ones listing only ~250 files are of course in error.
Eldritch is running 2.6.28-rc3 with that commit reverted. With 2.8.28-rc3 it
showed the incorrect number.


[root@dryad - Tue Nov 04 13:15:41]
[/usr/src/linux] for f in golem eldritch slyph kobold basilisk faun  dryad
nymph troll ogre banshee cockatrice; do echo $f $(ls -1 /net/$f/usr/bin/ |
wc -l); done

golem 1082
eldritch 1644
slyph 1718
kobold 1081
basilisk 267
faun 265

dryad 1595
nymph 245
troll 243
ogre 243
banshee 926
cockatrice 237



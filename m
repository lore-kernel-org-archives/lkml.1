Return-Path: <linux-kernel-owner+w=401wt.eu-S932372AbXBSPxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372AbXBSPxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 10:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932374AbXBSPxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 10:53:45 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:47601 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932372AbXBSPxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 10:53:44 -0500
Message-ID: <45D9C80A.2030905@drzeus.cx>
Date: Mon, 19 Feb 2007 16:53:46 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: hirofumi@mail.parknet.co.jp, LKML <linux-kernel@vger.kernel.org>
Subject: Racy NLS behaviour in FAT (and possible other fs)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm experiencing a rather odd behaviour with the character set conversion. If I
mount a vfat fs with utf8 and then create a file with invalid utf-8 sequences,
the file will briefly exist with these invalid sequences, then quickly convert
to a stripped version.

I haven't found an easy way to catch the race, but if I have nautilus open it
tends to catch it now and then (I get a file name with "<?>" replacing each bad
byte).

The race also seems to corrupt the in-memory state of the fs now and then. I
managed to create a file where "ls" shows "?" for most fields. Data seemed to
have made it to disk ok though (fsck didn't complain and a remount showed
everything as it should be).

Third, there seems to be a problem with not all syscalls being subjected to the
NLS transformation. Example:

$ echo foo > baråäö.txt
$ ls
foo.txt
$ echo foo > baråäö.txt
bash: baråäö.txt: File exists

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

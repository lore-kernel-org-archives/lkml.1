Return-Path: <linux-kernel-owner+w=401wt.eu-S1751652AbZIIGir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbZIIGir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 02:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZIIGiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 02:38:46 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:34229 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZIIGiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 02:38:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Z+wZ0daXmt/5AGjl7eKPATfXGwDUYNv24ox61KO7s3/aE6/1f/OIShj9cd+/ba5n8o
         Ueo/oZVoMCWWXONYypwNxF2dpYWpOHqugaILioO6x+/2g7XI3fhlqmkj/XrPOF0xeJxj
         deaf8tAw3tJKbYm6XLdUIlGMgJjf/5HFJtfoQ=
MIME-Version: 1.0
Date: Wed, 9 Sep 2009 02:38:47 -0400
Message-ID: <deaa866a0909082338i7a32d87cu267a5ed987462d67@mail.gmail.com>
Subject: Xorg server hanging/crashing kernel, esp. 2.6.31-rc9 (-rc8)
From: Robert Bradbury <robert.bradbury@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a situation [1] where I am trying to configure the Xorg
server (xorg.conf) to control multiple graphics cards with multiple
monitors.  I've got a specific case where the Xorg server appears to
be segfaulting when it is supposed to enter its "OPERATING" state and
in the process seems to take down the consoles and perhaps even the
kernel itself.

(I consider a kernel in a multi-user state with logged in telnet
sessions to be "up" while a kernel with unresponsive telnet sessions,
no response to ping's and no console VT switching capabilities to be
"hung" (it is reasonably useless)).

Now I would normally consider that Xorg crashing should not be able to
hang the kernel and it normally doesn't (returning to the console
state, leaving a stack trace in the Xorg.#.log file, etc.).  But I've
got clear cases in 2.6.31 where that doesn't appear to be the case.
The problem may extend back to ~2.6.28 or so when the KMS / UXA / EXA
transition started, maybe even earlier.

The details of the bug and associated files are discussed in the
Gentoo and Freedesktop bugzillas:
http://bugs.gentoo.org/show_bug.cgi?id=284223
https://bugs.freedesktop.org/show_bug.cgi?id=23804

Any help, esp. why is there doesn't appear to be a Linux Kernel
bugzilla and whether there is any documentation on how to debug a
"hung" kernel when the consoles & remote terminal access doesn't work
would be appreciated.

1. The situation involves trying to make a 2-PCI device (1 motherboard
Intel 915 + 1 PCIe R3450 (Radeon 620)  graphics card) drive 3
monitors.

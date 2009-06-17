Return-Path: <linux-kernel-owner+w=401wt.eu-S933791AbZFQOIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933791AbZFQOIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933611AbZFQOIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:08:21 -0400
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:44841 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933679AbZFQOIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:08:20 -0400
X-Greylist: delayed 1690 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jun 2009 10:08:20 EDT
Message-ID: <4A38F229.70504@ahsoftware.de>
Date: Wed, 17 Jun 2009 15:39:53 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20090208)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: asynchronous calls an the lack of --wait-for-completion options (e.g.
 modprobe, losetup, cryptsetup)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

during the last kernel versions I've got more and more problems with
scripts which are calling modprobe, losetup or e.g. cryptsetup.

The problem is that when I'm e.g. calling modprobe loop, loop might not
has finished it's initialization, when modprobe returns.

This leads me to such ugly scripts like
-----------------------------
if [ ! -b /dev/loop0 ]; then
   modprobe loop
   for i in $(seq 1 10) ; do
     if [ -b /dev/loop0 ]; then
       break;
     fi
     sleep 1
   done
fi
do something with /dev/loop0
-----------------------------

which leaves me in doubt if /dev/loop0 really is usable (or if the
module really has finished it's initialization) if /dev/loop0 appeared
(besides the unecessary seconds spended to sleep).

So I'm awaiting the time, when cp in "mkdir foo; cp bar foo" will fail,
because mkdir hasn't completed it's operation (but just started it).

My suggestion would be that all those tools should either offer an
option like --wait-for-completion, or, my prefered solution (which I
naively assume as how those userland-tools should behave), they should
by default wait for completion and could offer an option like
--asynchronous for the rare moments one really doesn't care if the
operation has completed when the appropriate userland-tool returns.

Another question could be, how to be sure if, e.g., modprobe loop
succeeded, if it returns while the operation hasn't finished.

Kind regards,

Alexander Holler


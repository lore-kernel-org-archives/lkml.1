Return-Path: <linux-kernel-owner+w=401wt.eu-S1759377AbYHaK4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377AbYHaK4a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 06:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758410AbYHaK4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 06:56:07 -0400
Received: from lucidpixels.com ([75.144.35.66]:34923 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758259AbYHaK4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 06:56:06 -0400
Date: Sun, 31 Aug 2008 06:56:04 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-raid@vger.kernel.org
Subject: 2.6.26 (x86 vs. x86_64) different /sys directory structure for md?
Message-ID: <alpine.DEB.1.10.0808310649390.4772@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have two hosts, an (md) raid5 on each:

Linux p26 2.6.26 #2 SMP Sat Jul 26 13:23:40 EDT 2008 i686 GNU/Linux
Linux p63 2.6.26 #2 SMP Sat Jul 26 08:21:07 EDT 2008 x86_64 GNU/Linux

Was going to run a check on my raids:

echo check > sync_action

I noticed:

For x86 (Debian Testing), the path to sync_action is:
/sys/block/md0/md/sync_action

For x86_64 (Debian Testing), the path to sync_action is:
/sys/devices/virtual/block/md0/md/sync_action

p26:/dev# find /sys/|grep -i sync_action
/sys/block/md0/md/sync_action
p26:/dev#

p63:~# find /sys/|grep -i sync_action
/sys/devices/virtual/block/md0/md/sync_action
/sys/devices/virtual/block/md3/md/sync_action
/sys/devices/virtual/block/md2/md/sync_action
/sys/devices/virtual/block/md1/md/sync_action
p63:~#

The kernels are compiled similarly in terms of overall configuration, I 
will need to take this into account for scripting array checks etc, but I 
was curious why are they different between architectures and is it going 
to change in the future?  Should one take the path to sync_action with a 
grain of salt?  Or do I have an incorrect configuration option specified 
somewhere that had made this occur?

http://home.comcast.net/~jpiszcz/20080831/p26-config.txt
http://home.comcast.net/~jpiszcz/20080831/p63-config.txt

Justin.

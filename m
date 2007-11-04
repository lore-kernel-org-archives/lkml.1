Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbXKDOVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbXKDOVG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 09:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbXKDOUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 09:20:55 -0500
Received: from mx1.wp.pl ([212.77.101.5]:63583 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbXKDOUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 09:20:54 -0500
Date: Sun, 4 Nov 2007 15:20:42 +0100
From: Janek Kozicki <janek_listy@wp.pl>
To: linux-kernel@vger.kernel.org
Subject: telling mdadm to use spare drive.
Message-ID: <20071104152042.469b0d04@absurd>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [seN0]                               
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I finished copying all data from old disc hdc to my shiny new
RAID5 array (/dev/hda3 /dev/sda3 missing). Next step is to create a
partition on hdc and add it to the array. And so I did this:

# mdadm --add /dev/md1 /dev/hdc3

But then I had a problem - the /dev/hdc3 was a spare, it didn't
resync automatically:

# mdadm -D /dev/md1
[....]
    Number   Major   Minor   RaidDevice State
       0       3        3        0      active sync   /dev/hda3
       1       8        3        1      active sync   /dev/sda3
       2       0        0        2      removed

       3      22        3        -      spare   /dev/hdc3


I wanted to tell mdadm to use the spare device, and I wasn't sure how
to do this, so I tried following:

# mdadm --stop /dev/md1
# mdadm --assemble --update=resync /dev/md1 /dev/hda3 /dev/sda3 /dev/hdc3

Now, 'mdadm -D /dev/md1' says:
[...]
    Number   Major   Minor   RaidDevice State
       0       3        3        0      active sync   /dev/hda3
       1       8        3        1      active sync   /dev/sda3
       3      22        3        2      spare rebuilding   /dev/hdc3


I'm writing here just because I want to be sure that I added this new
device correctly, I don't want to make any stupid mistake here...

# cat /proc/mdstat

md1 : active raid5 hda3[0] hdc3[3] sda3[1]
      966807296 blocks super 1.1 level 5, 128k chunk, algorithm 2 [3/2] [UU_]
      [=>...................]  recovery =  6.2% (30068096/483403648) finish=254.9min speed=29639K/sec
      bitmap: 8/8 pages [32KB], 32768KB chunk

Was there a better way to do this, is it OK?

-- 
Janek Kozicki                                                         |

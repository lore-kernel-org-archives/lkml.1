Return-Path: <linux-kernel-owner+w=401wt.eu-S1765824AbXGPRMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765824AbXGPRMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 13:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbXGPRMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 13:12:34 -0400
Received: from oxford.dsc.net ([213.161.73.145]:57675 "EHLO oxford.dsc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbXGPRMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 13:12:33 -0400
X-Greylist: delayed 3718 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jul 2007 13:12:33 EDT
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Transfer-Encoding: 7bit
Message-Id: <DB77ED1B-5539-4600-B79A-AFF08978D4D5@dsc.net>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
To: linux-kernel@vger.kernel.org
From: Philip McCarthy <webquestions@dsc.net>
Subject: kernel multipath messages
Date: Mon, 16 Jul 2007 17:10:31 +0100
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

We are running an Intel server with Linux Centos 4.2 and kernel  
2.6.9-22.ELsmp. The server has recently started to produce multipath  
related error messages a regular intervals every couple of days. From  
looking at the messages it appears that the fault corrects itself  
after about 30 seconds.

Can anyone tell me what might causing these multipath error messages  
and what the messages actually mean?

The server is part of a simple SAN using Qlogic fibre controllers.  
The Qlogic controller is not showing any errors an neither is the  
RAID disk enclosure.


# Log Extract - /var/log/messages
Jun 13 07:56:21 servername kernel: SCSI error : <4 0 0 1> return code  
= 0x20000
Jun 13 07:56:21 servername kernel: end_request: I/O error, dev sde,  
sector 2336731952
Jun 13 07:56:21 servername kernel: multipath: IO failure on sde,  
disabling IO path.
Jun 13 07:56:21 servername kernel: 	Operation continuing on 1 IO paths.
...
Jun 13 07:56:21 servername kernel: multipath: sde: rescheduling  
sector 2336731960
Jun 13 07:56:21 servername kernel: multipath: sde: redirecting sector  
2336731952 to another IO path
Jun 13 07:56:26 servername kernel: multipath: sde: rescheduling  
sector 2336749632
Jun 13 07:56:26 servername kernel: end_request: I/O error, dev sde,  
sector 2336749632
Jun 13 07:56:26 servername kernel: multipath: sde: rescheduling  
sector 2336749640
Jun 13 07:56:26 servername kernel: multipath: sde: rescheduling  
sector 2336749648
Jun 13 07:56:26 servername kernel: multipath: sde: rescheduling  
sector 2336749656
Jun 13 07:56:26 servername kernel: multipath: sde: rescheduling  
sector 2336749664
Jun 13 07:56:43 servername kernel: md: cannot remove active disk sde  
from md1 ...
Jun 13 07:56:46 servername kernel: md: cannot remove active disk sde  
from md1 ...
...
Jun 13 07:56:51 servername kernel: MULTIPATH conf printout:
Jun 13 07:56:51 servername kernel:  --- wd:1 rd:2
Jun 13 07:56:51 servername kernel:  disk0, o:0, dev:sde
Jun 13 07:56:51 servername kernel:  disk1, o:1, dev:sdc
Jun 13 07:56:51 servername kernel: MULTIPATH conf printout:
Jun 13 07:56:51 servername kernel:  --- wd:1 rd:2
Jun 13 07:56:51 servername kernel:  disk1, o:1, dev:sdc
Jun 13 07:56:51 servername kernel: md: unbind<sde>
Jun 13 07:56:51 servername kernel: md: export_rdev(sde)
Jun 13 07:56:55 servername kernel: md: bind<sde>
Jun 13 07:56:56 servername kernel: MULTIPATH conf printout:
Jun 13 07:56:56 servername kernel:  --- wd:1 rd:2
Jun 13 07:56:56 servername kernel:  disk1, o:1, dev:sdc
Jun 13 07:56:56 servername kernel: MULTIPATH conf printout:
Jun 13 07:56:56 servername kernel:  --- wd:2 rd:2
Jun 13 07:56:56 servername kernel:  disk0, o:1, dev:sde
Jun 13 07:56:56 servername kernel:  disk1, o:1, dev:sdc

# mdadm.conf
DEVICE /dev/sd[b-e]*
ARRAY /dev/md0 level=multipath num-devices=2  
UUID=7698cb38:857d32ab:ba6453aa:f003a129 devices=/dev/sdd,/dev/sdb
ARRAY /dev/md1 level=multipath num-devices=2  
UUID=332d4ae0:8d98bb52:952dbf27:2d0ecf6b devices=/dev/sde,/dev/sdc

Please cc any replies to webquestions@dsc.net

Any help much appreciated.

Philip


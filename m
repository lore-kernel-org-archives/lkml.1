Return-Path: <linux-kernel-owner+w=401wt.eu-S1762235AbXGJLKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762235AbXGJLKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 07:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbXGJLKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 07:10:42 -0400
Received: from ns4.imago.de ([213.69.223.130]:52164 "EHLO mx4.imago.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754812AbXGJLKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 07:10:41 -0400
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jul 2007 07:10:41 EDT
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: binary
MIME-Version: 1.0
CC: mantel@imago.de
Subject: Problem with stat and nfsmounts using kernel 2.6.21+
Reply-To: mantel@imago.de
To: linux-kernel@vger.kernel.org
From: Tobias Mantel <mantel@imago.de>
X-Mailer: x-organizer.de (3.26.1)
Message-ID: <4502119.20070710130239@x-organizer.de>
Date: Tue, 10 Jul 2007 13:02:39 +0200
X-Priority: 3 (Normal)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've got a problem with stat (/usr/bin/stat) after updating my linux kernel from 2.6.18 to 2.6.21.3
The problem appeared while using find with the -mount option to exclude files which are not at the local drive.

With kernel 2.6.18 the command "find / -mount" stayed at local disc and didn't go down in paths mounted via nfs to my local filesystem.
After updating to kernel version 2.6.21.3 find no longer stays at local drive and goes down in all paths mounted via nfs.
I recognized that stat now no longer handles filesystems mounted via nfs to / with a different device id. The device id is the same as for /

Example:

Linux 2.6.18 (ok)
------------------------
stat / | grep Device
Device: ch/12d  Inode: 552417276   Links: 26

/usr/www/tmp is mounted using nfs
stat /usr/www/tmp/ --filesystem | grep Type
ID: 0        Namelen: 255     Type: nfs
stat /usr/www/tmp/ | grep Device
Device: 17h/23d Inode: 671557496   Links: 2

/tmp/ is another partition at local disc mounted to /
stat /tmp/ --filesystem | grep Type
ID: 305      Namelen: 255     Type: xfs
stat /tmp/ | grep Device
Device: 305h/773d       Inode: 128         Links: 6

other linux box

Linux 2.6.21.3 (not ok)
---------------------------------
stat / | grep Device
Device: eh/14d  Inode: 1208534959  Links: 26

/usr/www/tmp is mounted using nfs
stat /usr/www/tmp/ --filesystem | grep Type
ID: 0        Namelen: 255     Type: nfs
stat /usr/www/tmp/ | grep Device
Device: eh/14d  Inode: 671557496   Links: 2

/tmp/ is another partition at local disc mounted to /
stat /tmp/ --filesystem | grep Type
ID: 805      Namelen: 255     Type: xfs
stat /tmp/ | grep Device
Device: 805h/2053d      Inode: 128         Links: 5

I have another box running with 2.6.20 and it behaves like the box running 2.6.18, everthing works fine.

Since no other changes than the kernel update was performed at the server, I think maybe sothing changed between 2.6.20 and 2.6.21 which leeds stat zu no longer mountet nfs shares with other device ids than the root device id.

I'm using SUSE LINUX 10.1 with a custom kernel form kernel.org.
Hopefully someone can give me a hint or can confirm my notice.

Because I have not subscribed the linux kernel mailing list, please send answers in CC to: mantel@imago.de
If somebody needs futher information or tests, please let me know.

Thank you so far and may linux/opensource live forever.

Kind regards,

 Tobias Mantel
Systemadministration/Netzwerk
Junior Level Linux Professional (LPIC-1)

------------------------------------------------------------------
Imago Informationstechnologie GmbH
Sauerwiesen 6
67661 Kaiserslautern
tel. 06301-708-139
fax. 06301-708-222
mailto:mantel@imago.de
http://www.imago.de
HRB 3008 Amtsgericht Kaiserslautern
USt-IdNr.: DE 174941022
Geschäftsführer: Herr Dipl.-Ing. Christian Keller 

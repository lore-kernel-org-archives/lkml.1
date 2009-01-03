Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbZACLrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbZACLrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 06:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbZACLrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 06:47:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45444 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbZACLrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 06:47:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: [Regression] Build failure in current mainline - firmware related
Date: Sat, 3 Jan 2009 12:47:14 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-tst; KDE/4.1.3; x86_64; ; )
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901031247.14977.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get the following error from 'make modules_install' on my test boxes:

  HOSTCC  firmware/ihex2fw                                                             
/home/rafael/src/linux-2.6/firmware/ihex2fw.c:268: fatal error: opening dependency file firmware/.ihex2fw.d: Read-only file system                                            
compilation terminated.                                                                
make[3]: *** [firmware/ihex2fw] Error 1                                                
make[2]: *** [_modinst_post] Error 2                                                   
make[1]: *** [sub-make] Error 2                                                        
make: *** [all] Error 2

where the configuration is that the kernel is compiled on a build box
with 'make O=<destdir> -j5' and then <destdir> is mounted over NFS read-only by
each test box (full path to this directory is the same on the build box and on
the test boxes).  Then, I cd into <destdir>, run 'make modules_install' and get
the error above.

2.6.28 didn't have this problem.

Thanks,
Rafael

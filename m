Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbYECFJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbYECFJg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 01:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYECFJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 01:09:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:16360 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbYECFJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 01:09:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=SvzgRPH20Kl04EEGBnyHqIlMTubottA/44E/yw7yPproECBJZe5YSBpyAEHhThPcpZrXmstwUmyb4+BFATYgD22RDYf+D/UFoKHbXg/98XuacMgceTwb34R7JBksWP+USQrG/2FktSMIKHtOcXEPGIYrXBMdya193DoT9aRX5Sc=
Message-ID: <f24d23310805022209l58e3f227t2ced788a4115139e@mail.gmail.com>
Date: Sat, 3 May 2008 10:39:23 +0530
From: "debian developer" <debiandev@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, kernelnewbies@nl.linux.org,
       kernel-janitors@vger.kernel.org
Subject: Resend: [Patch 1/1] kernel/time/ntp.c : fix warning
Cc: dmitri.vorobiev@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mailer spoilt the previous send... just realized that copy does'nt
work, sorry for that
Hello,

On compiling on a Xeon machine i get the following warning

kernel/time/ntp.c: In function `do_adjtimex':
kernel/time/ntp.c:328: warning: comparison of distinct pointer types
lacks a cast
kernel/time/ntp.c:329: warning: comparison of distinct pointer types
lacks a cast

This is with gcc version 3.4.3. The following patch fixes this...

--- linux-2.6.25/kernel/time/ntp.c.orig	2008-05-03 04:27:20.000000000 +0530
+++ linux-2.6.25/kernel/time/ntp.c	2008-05-03 04:45:06.000000000 +0530
@@ -325,8 +325,8 @@ int do_adjtimex(struct timex *txc)
 		     * Scale the phase adjustment and
 		     * clamp to the operating range.
 		     */
-		    time_offset = min(time_offset, (s64)MAXPHASE * NSEC_PER_USEC);
-		    time_offset = max(time_offset, (s64)-MAXPHASE * NSEC_PER_USEC);
+		    time_offset = min(time_offset, (s64)(MAXPHASE * NSEC_PER_USEC));
+		    time_offset = max(time_offset, (s64)(-MAXPHASE * NSEC_PER_USEC));

 		    /*
 		     * Select whether the frequency is to be controlled

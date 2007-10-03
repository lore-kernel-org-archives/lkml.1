Return-Path: <linux-kernel-owner+w=401wt.eu-S1758162AbXJCLXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbXJCLXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 07:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbXJCLWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 07:22:55 -0400
Received: from rosi.naasa.net ([212.8.0.13]:59171 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713AbXJCLWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 07:22:54 -0400
X-Greylist: delayed 1444 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2007 07:22:54 EDT
From: Joerg Platte <lists@naasa.net>
Reply-To: jplatte@naasa.net
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rcX SG_GET_SCSI_ID regression?
Date: Wed, 3 Oct 2007 12:58:45 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200710031258.46266.lists@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sane is not able to detect my old SCSI scanner with kernel 2.6.23-rc9. The 
scanner was found with 2.6.22.8. According to strace the behavior of the 
SG_GET_SCSI_ID ioctl changed:

2.6.22.8:
open("/dev/scanner", O_RDWR|O_NONBLOCK|O_EXCL) = 3
ioctl(3, SG_SET_TIMEOUT, 0xbfe40624)    = 0
ioctl(3, SG_GET_VERSION_NUM, 0x8063fa4) = 0
ioctl(3, SG_GET_SCSI_ID, 0xbfe405e0)    = 0

2.6.23-rc9:
open("/dev/scanner", O_RDWR|O_NONBLOCK|O_EXCL) = 3
ioctl(3, SG_SET_TIMEOUT, 0xbf84a834)    = 0
ioctl(3, SG_GET_VERSION_NUM, 0x8062524) = 0
ioctl(3, SG_GET_SCSI_ID, 0xbf84a7f0)    = -1 ENOTTY (Inappropriate ioctl for 
device)

Is this an intentional change?

regards,
Jörg

-- 
PGP Key: send mail with subject 'SEND PGP-KEY' PGP Key-ID: FD 4E 21 1D
PGP Fingerprint: 388A872AFC5649D3 BCEC65778BE0C605


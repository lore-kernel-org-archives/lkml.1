Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbXJCMxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbXJCMxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 08:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbXJCMw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 08:52:59 -0400
Received: from rosi.naasa.net ([212.8.0.13]:38852 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506AbXJCMw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 08:52:58 -0400
From: Joerg Platte <lists@naasa.net>
Reply-To: jplatte@naasa.net
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rcX SG_GET_SCSI_ID regression?
Date: Wed, 3 Oct 2007 14:52:54 +0200
User-Agent: KMail/1.9.7
References: <200710031258.46266.lists@naasa.net>
In-Reply-To: <200710031258.46266.lists@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200710031452.55506.lists@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 3. Oktober 2007 schrieb Joerg Platte:
Hi,

> 2.6.22.8:
> open("/dev/scanner", O_RDWR|O_NONBLOCK|O_EXCL) = 3
> ioctl(3, SG_SET_TIMEOUT, 0xbfe40624)    = 0
> ioctl(3, SG_GET_VERSION_NUM, 0x8063fa4) = 0
> ioctl(3, SG_GET_SCSI_ID, 0xbfe405e0)    = 0
>
> 2.6.23-rc9:
> open("/dev/scanner", O_RDWR|O_NONBLOCK|O_EXCL) = 3
> ioctl(3, SG_SET_TIMEOUT, 0xbf84a834)    = 0
> ioctl(3, SG_GET_VERSION_NUM, 0x8062524) = 0
> ioctl(3, SG_GET_SCSI_ID, 0xbf84a7f0)    = -1 ENOTTY (Inappropriate ioctl
> for device)

After some reboots and tests I discovered, that this error occurs only when 
the scanner was turned off during system boot and was discovered later by 
invoking the following script:
for device in /sys/class/scsi_host/host*/scan ; do
        echo "0 - -" > $device
done
With 2.6.22 and before the scanner was fully functional when discovered by a 
bus rescan.

regards,
Jörg

-- 
PGP Key: send mail with subject 'SEND PGP-KEY' PGP Key-ID: FD 4E 21 1D
PGP Fingerprint: 388A872AFC5649D3 BCEC65778BE0C605


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbYKLRoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbYKLRoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYKLRoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:44:11 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:54718 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbYKLRoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:44:10 -0500
Message-ID: <491B15E7.8000501@trn.iki.fi>
Date: Wed, 12 Nov 2008 19:44:07 +0200
From: =?ISO-8859-1?Q?Lasse_K=E4rkk=E4inen?= <tronic+bpsk@trn.iki.fi>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Resizing block devices that are in use
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the kernel does not seem to resize SCSI devices when rescan is 
done, if the device is in use (e.g. there's a filesystem mounted on it). 
Additionally, it also won't resize it if rescan (changing size in 
hardware) is done first while mounted and then the device is unmounted, 
even if rescan is attempted again.

Steps to reproduce:
1. mount a filesystem on a SCSI device
2. resize the disk (e.g. grow hardware RAID array)
3. echo 1 > "/sys/bus/scsi/devices/0:0:1:0"
4. unmount the filesystem
5. echo 1 > "/sys/bus/scsi/devices/0:0:1:0" again
6. the size of the device (e.g. /dev/sdb) still hasn't changed

A preferrable solution (to me) would be to resize the device as soon as 
rescan is done, no matter if it is in use or not. It will fix the bug 
and the "feature" both at the same time.


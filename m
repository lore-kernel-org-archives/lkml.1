Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbYJ3KDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbYJ3KDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 06:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbYJ3KCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 06:02:52 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:45143 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbYJ3KCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 06:02:51 -0400
From: Sarangi_Santosh@emc.com
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: PROBLEM: ioctl (HDIO_GETGEO) on partition
Date: Thu, 30 Oct 2008 06:02:17 -0400
Message-ID: <A68C75D82BABF64AB13A6AC1875BF275052D707A@CORPUSMX10B.corp.emc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: PROBLEM: ioctl (HDIO_GETGEO) on partition
Thread-Index: Ack6dpdjrnEbZSLjQHKwsNLEjbSnOA==
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 30 Oct 2008 10:02:33.0317 (UTC) FILETIME=[A0AF6150:01C93A76]
X-RSA-Inspected: yes
X-RSA-Classifications: 
X-RSA-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I am into a problem where the ioctl (HDIO_GETGEO) if failing on a device
partition(ex: /dev/emcpowerg1), which is working fine for full device (
ex: /dev/emcpowerg).
Basically I am trying to get start offset of the device partition
(hd_geometry.start).
The host information where I am seeing the above problem is as follows:

Linux ampersandmex01 2.6.18-53.el5PAE #1 SMP Wed Oct 10 16:48:18 EDT
2007 i686 i686 i386 GNU/Linux 

Red Hat Enterprise Linux Server release 5.1 (Tikanga)


Can anyone suggest if there is any patch available, so that the problem
can be resolved ?
If the patch is not available, then is there any other way, I can get
the above information without using  the ioctl (HDIO_GETGEO) ?

I am pasting the code snip set below for your reference.

Thanks,
-Santosh

<code snip>
  int                  fd;
  int                  sts;
  struct hd_geometry   hd_geometry_rec;
  unsigned int                offset;

  
  if ((fd = open(p_ppdevname, O_RDONLY | O_NONBLOCK)) < 0)
    {
        return OS_SYSTEM_CALL_FAILED;
    }
  if ((sts = ioctl(fd, HDIO_GETGEO, &hd_geometry_rec)) < 0) ------->
ioctl((HDIO_GETGEO)  is failing for device partition (/dev/emcpowerg1)
    {
      close(fd);
      return OS_SYSTEM_CALL_FAILED;
    }
  offset = (unsigned int) hd_geometry_rec.start;
.
.
.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbZGCLQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbZGCLQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 07:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZGCLQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 07:16:37 -0400
Received: from smtp.ispras.ru ([83.149.198.201]:59807 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbZGCLQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 07:16:36 -0400
X-Greylist: delayed 1400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jul 2009 07:16:36 EDT
From: iceberg <strakh@ispras.ru>
Organization: ISP RAS
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: bug at ./drivers/media/video/hdpvr/hdpvr-core.c
Date: Fri, 3 Jul 2009 14:53:27 +0400
User-Agent: KMail/1.10.3 (Linux/2.6.27.23-0.1-default; KDE/4.1.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907031453.27467.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	KERNEL_V	ERSION: 2.6.30	
	SUBJECT:  in function device_authorization mutex is not released on error 
path.
	DESCRIBE:
	In ./drivers/media/video/hdpvr/hdpvr-core.c in function device_authorization: 
	If after mutex lock (line 4) usb_control_msg returns ret!=46 we go to label 
error. In this case before exit from function mutex must be 	unlocked.

01) static int device_authorization(struct hdpvr_device *dev)
02) {
03) ............
04)         mutex_lock(&dev->usbc_mutex);                                                    
05)        ret = usb_control_msg(dev->udev,
06)                               usb_rcvctrlpipe(dev->udev, 0),
07)                              rcv_request, 0x80 | request_type,
08)                              0x0400, 0x0003,
09)                              dev->usbc_buf, 46,10000);
10)	        if (ret != 46) {
11)              v4l2_err(&dev->v4l2_dev,
12)                         "unexpected answer of status request, len %d\n", 
ret);
13)                goto error;
14)        }
15) .................
16) error:
17)
18)        return retval;
19) }
                

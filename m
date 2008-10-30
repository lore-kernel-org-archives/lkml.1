Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbYJ3T6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbYJ3T6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYJ3T6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:58:22 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:47662 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbYJ3T6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:58:21 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <490A11DB.3060703@gmail.com>
Date: Thu, 30 Oct 2008 19:58:19 +0000
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: media/common/tuner selection when using a webcam and i2c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

I've been trying to track down why when I enable i2c (for some embedded
sensors)
and the options required to get a v4l gspca camera I end up with a lot
of unnecessary tuner modues.

It looks to me like some false assumptions are being made within the Kconfig
files.

VIDEO_MEDIA gets enabled as VIDEO_DEV is and DVB_CORE is not.
(in media/Kconfig)

and i2c is enabled because I'm using it for numerous other things.

Thus, the

config MEDIA_TUNER
       tristate
       defaults VIDEO_MEDIA && I2C
       depends on VIDEO_MEDIA && I2C
       select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMIZE

enables a lot of tuner drivers.

Now once I'd figured out what was happening it is clear these
can be disabled by using menuconfig MEDIA_TUNER_CUSTOMIZE.

However, to me the fact I needed to do this suggests some false assumptions
in the media Kconfig files, given I never specified anything that would
ever actually have a tuner.

Jonathan Cameron


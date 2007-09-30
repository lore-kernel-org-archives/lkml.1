Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbXI3XDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbXI3XDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 19:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbXI3XDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 19:03:33 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:33243 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbXI3XDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:03:32 -0400
Date: Sun, 30 Sep 2007 19:03:20 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: 2.6.23-rc8, no tvtime
To: linux-kernel@vger.kernel.org
Message-id: <200709301903.20746.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;

I have a pcHDTV-3000 card in this box.  This is a cx88 based card AFAIK.

I had a need to check something with tvtime today and found it couldn't 
open /dev/video0

Checking in /dev, there indeed is no such animal, or anything seemingly video 
related.

An lsmod|grep cx88 returns:
cx8802                 13572  0
cx8800                 25568  0
compat_ioctl32          1280  1 cx8800
cx88xx                 56612  2 cx8802,cx8800
ir_common              29444  1 cx88xx
i2c_algo_bit            5124  1 cx88xx
video_buf              18308  3 cx8802,cx8800,cx88xx
btcx_risc               3848  3 cx8802,cx8800,cx88xx
tveeprom               13584  1 cx88xx
videodev               23936  2 cx8800,cx88xx
v4l2_common            14592  3 cx8800,cx88xx,videodev
i2c_core               17808  6 
nvidia,cx88xx,i2c_algo_bit,tveeprom,eeprom,i2c_nforce2

A grep of dmesg for cx88 returns:
cx2388x cx88-mpeg Driver Manager version 0.0.6 loaded

Which seems a rather sparse return to me.
 
And I have this in my rc.local to load it all:
modprobe nvidia-agp
modprobe -r cx8802 cx8800 cx88-alsa cx88xx
modprobe cx88xx tuner=60
modprobe cx8800
modprobe cx8802

I had been getting an error from the rc.local at startup in the logs, and took 
the offending line out about 2 weeks ago, but I believe it did work prior to 
that.

Can anyone spot the mistake above?  Or do we have a real problem with rc8?

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Is he the MAGIC INCA carrying a FROG on his shoulders??  Is the FROG
his GUIDELIGHT??  It is curious that a DOG runs already on the ESCALATOR ...

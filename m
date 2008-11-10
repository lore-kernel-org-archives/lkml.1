Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbYKJLpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbYKJLpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 06:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbYKJLoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 06:44:55 -0500
Received: from mail.ocs.com.au ([202.134.241.204]:26511 "EHLO mail.ocs.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbYKJLoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 06:44:54 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 (debian 1:2.7.2-16) with nmh-1.2
From: Keith Owens <kaos@ocs.com.au>
To: "Peter Teoh" <htmldeveloper@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: USB HDD or filesystem bugs? 
In-reply-to: Your message of "Mon, 10 Nov 2008 15:41:10 +0800."
             <804dabb00811092341i40741745kb915215cc9356e25@mail.gmail.com> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 10 Nov 2008 22:44:51 +1100
Message-ID: <10452.1226317491@ocs10w>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008 15:41:10 +0800, 
"Peter Teoh" <htmldeveloper@gmail.com> wrote:
>But coming back to the same original hardware gave error again:
>
>/mnt/download/tmp>df
>Filesystem           1K-blocks      Used Available Use% Mounted on
>/dev/sdb1             38456308  33415180   3087628  92% /
>udev                   1541888       212   1541676   1% /dev
>/dev/hdc1             96132940  65644452  25605132  72% /hdc1
>/dev/hdc2             96132968  47080232  44169380  52% /hdc2
>/dev/sda1             83222548   5558748  73469632   8% /mnt/test3
>/dev/sda3             77507676  12215840  61385632  17% /sda3
>/dev/sda3             77507676  12215840  61385632  17% /media/disk
>/dev/sdd1             38456308  29907992   6594816  82% /media/disk-2
>/dev/sdd2             38456340  29737232   6765604  82% /media/disk-3
>/dev/sde4             40631988  28381852  10152852  74% /media/_1
>/dev/sde5             14659280  14656544      2736 100% /media/disk-4
>/dev/sde2             38448304  29995736   6499468  83% /media/disk-5
>/dev/sde1             39381744  11281468  26099784  31% /media/disk-6
>/dev/sdf2             38456340  29737232   6765604  82% /media/disk-1
>/dev/sdf3             76904380  28664160  44333616  40% /media/disk-7
>/dev/sdf1             38456308  29907992   6594816  82% /media/disk-8
>/dev/sdg1             39381744  11281468  26099784  31% /media/disk-9
>/dev/sdg2             38448304  29995736   6499468  83% /media/disk-10
>/dev/sdg4             40631988  28381852  10152852  74% /media/_1_
>/dev/sdg5             14659280  14656544      2736 100% /media/disk-11

/dev/sde and /dev/sdg are duplicates.  Access to the same filesystem
via two paths is causing your corruption.  AFAICT this is not a kernel
problem, something in your hardware configuration is making the same
disk appear at two separate locations.  Check your cabling and back end
configuration.  The boot messages will tell you which controller,
channel and LUN the devices are being found on.

You also have /dev/sda3 mounted twice.  How did you manage that?


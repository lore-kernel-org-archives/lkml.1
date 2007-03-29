Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbXC2EC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbXC2EC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 00:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbXC2EC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 00:02:58 -0400
Received: from smtpout.mac.com ([17.250.248.174]:51239 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbXC2EC5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 00:02:57 -0400
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Mar 2007 00:02:57 EDT
In-Reply-To: <Pine.LNX.4.61.0703240023220.10028@yvahk01.tjqt.qr>
References: <460236CE.1030303@slax.org> <20070322110058.GB23664@tatooine.rebelbase.local> <46026A92.4020106@slax.org> <20070322144210.73dfaf83.dada1@cosmosbay.com> <Pine.LNX.4.61.0703230232320.9555@yvahk01.tjqt.qr> <Pine.LNX.4.61.0703240023220.10028@yvahk01.tjqt.qr>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <89DC3EEA-72A3-4F6A-9FD8-FD5D5010BE39@mac.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Tomas M <tomas@slax.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
From: Kyle Moffett <mrlinuxman@mac.com>
Subject: Re: [PATCH] max_loop limit
Date: Wed, 28 Mar 2007 23:54:17 -0400
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 23, 2007, at 19:26:34, Jan Engelhardt wrote:
> here's one. Allocates all the fluff dynamically. It does not create  
> any dev nodes by itself, so you need to do it (à la mdadm), but  
> you'll get all 1048576 available minors.
>
> +static LIST_HEAD(loop_devices);

Maybe an rbtree would work better here?  Maximum number of nodes  
traversed to get to the bottom of the tree given 2^(20) loop devices  
is 19 as opposed to the 2^(20) for a linked list.  Also, to preserve  
compatibility with existing userspace loop tools you should probably  
always allocate one extra loop device.  Keep a "highest used loopdev"  
number and create the one after that so that udev will autocreate a  
dev node for it.

Cheers,
Kyle Moffett


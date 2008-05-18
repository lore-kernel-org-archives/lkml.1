Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbYERUcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbYERUcv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 16:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbYERUcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 16:32:41 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:32855 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbYERUck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 16:32:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4830925B.5010802@s5r6.in-berlin.de>
Date: Sun, 18 May 2008 22:32:27 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: linux1394-devel@lists.sourceforge.net,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] SCSI and FireWire: fix/add START STOP UNIT for	SBP-2
 disks
References: <20080429232606.GA14261@dose.home.local> <481874BD.5010807@s5r6.in-berlin.de> <20080507180042.GA32629@dose.home.local> <tkrat.327b59f1366f8ea0@s5r6.in-berlin.de> <tkrat.635f52f7035be2bc@s5r6.in-berlin.de> <tkrat.5cf7605228f0006a@s5r6.in-berlin.de> <20080516062315.GA4350@dose.home.local> <tkrat.ad2cb91dd8644559@s5r6.in-berlin.de> <20080518173511.GA14742@dose.home.local>
In-Reply-To: <20080518173511.GA14742@dose.home.local>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tino Keitel wrote:
> Now I need to figure out how to get the Firewire disk to spin down
> using HAL. It looks like HAL just uses /usr/bin/eject, which just sends
> a START STOP UNIT command without power conditions set, so the kernel
> can't do anything here.

What if you teach hal to unbind sd from the respective scsi_device?
"echo -n 123:0:0:0 > /sys/bus/scsi/drivers/sd/unbind" is a manual way to 
do it.  And the "bind" file does the reverse.

Or replace /usr/bin/eject by a shell script of yours which calls 
sg_start when you need it to...
-- 
Stefan Richter
-=====-==--- -=-= =--=-
http://arcgraph.de/sr/

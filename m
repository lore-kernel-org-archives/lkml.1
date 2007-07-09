Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbXGIOJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbXGIOJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 10:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbXGIOJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 10:09:39 -0400
Received: from andromeda.dapyr.net ([69.45.6.100]:60039 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbXGIOJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 10:09:38 -0400
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jul 2007 10:09:38 EDT
Date: Mon, 9 Jul 2007 10:02:42 -0400
From: Konrad Rzeszutek <konrad@darnok.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Inhibit NMI watchdog when Alt-SysRq-T operation is underway.
Message-ID: <20070709140242.GA18098@andromeda.dapyr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On large memory configuration with not so fast CPUs the NMI watchdog 
is triggered when memory addresses are being gathered and printed. 
The code paths for Alt-SysRq-t are sprinkled with touch_nmi_watchdog 
in various places but not in this routine (or in the loop that utilizes
this function). The patch has been tested for regression on large CPU+memory 
configuration (128 logical CPUs + 224 GB) and 1,2,4,16-CPU sockets with various 
memory sizes (1,2,4,6,20). 

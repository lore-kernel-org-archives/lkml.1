Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbYE2Gh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbYE2Gh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 02:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYE2Ghq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 02:37:46 -0400
Received: from drutsystem.com ([80.72.38.138]:3513 "EHLO drutsystem.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbYE2Ghp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 02:37:45 -0400
Message-ID: <483E4F36.8050902@ziu.info>
Date: Thu, 29 May 2008 08:37:42 +0200
From: Michal Soltys <soltys@ziu.info>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-raid@vger.kernel.org
Cc: Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <483DE612.5000804@tmr.com>
In-Reply-To: <483DE612.5000804@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV on drutsystem.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> A very nice bit of work, my only questions is if you ever feel motivated 
> to repeat this test, it would be fun to do it with ext3 (or ext4) using 
> the stride= parameter. I did limited testing and it really seemed to 
> help, but nothing remotely as format as your test.
> 

Speaking about which, it would probably be good to adjust a little how 
the filesystem is created and mounted (both in xfs and ext3/4 cases). 
E.g. lazy-count=1 is still not the default last time I checked mkfs.xfs. 
And even ext4.txt from kernel documentation recommends mounting it with 
data=writeback,nobh when doing comparison with metadata journaling 
filesystems (the same would go for ext3).

Along with different journal sizes, keeping an eye on stripe & 
stripe-width, and other settings that might be of interest.

Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbXGKLq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbXGKLq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761191AbXGKLqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:46:49 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:51281 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760057AbXGKLqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:46:48 -0400
Message-ID: <4694C30E.1030607@linux.vnet.ibm.com>
Date: Wed, 11 Jul 2007 17:16:22 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Shailabh Nagar <nagar1234@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Optimize struct task_delay_info
References: <1184138034.3068.51.camel@ymzhang>
In-Reply-To: <1184138034.3068.51.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang, Yanmin wrote:
> struct task_delay_info is used by per process block I/O delay statistics
> feature which is useful in kernel. This struct is not optimized.
> 
> My patch against kernel 2.6.22 shrinks it a half.
> 
> 1) Delete blkio_start and blkio_end. As the collection happens in
> io_schedule and io_schedule_timeout, we use local variables to
> replace them;
> 2) Delete lock. The change to the protected data has no nested cases.
> In addition, the result is for performance data collection, so it’s
> unnecessary to add such lock. 
> 3) Delete flags. It just has one value. Use the most significant bit of
> blkio_delay (64 bits) to mark it..
> 
> 
> Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>

Hi, Yanmin,

Did you see any particular performance issues with the delay accounting
patches? Is the patch tested; could you please provide test results?

Meanwhile, I'll review these patches and I am correcting Shailabh's id
to his new email id.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

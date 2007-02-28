Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbXB1MLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbXB1MLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 07:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932173AbXB1MLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 07:11:11 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:41646 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbXB1MLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 07:11:10 -0500
Date: Wed, 28 Feb 2007 13:10:40 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Xiaoning Ding <dingxn@cse.ohio-state.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: a bug in AS scheduler?
Message-ID: <20070228121040.GW3733@kernel.dk>
References: <45E5038F.1090200@cse.ohio-state.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E5038F.1090200@cse.ohio-state.edu>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27 2007, Xiaoning Ding wrote:
> Hi,
> 
> I am reading the source code AS scheduler in 2.6.18(as-ioscheduler.c).
> In function as_close_req, variable delay is in millisecond, while
> ad->antic_expire is in jiffies. Doesn't the comparison of delay and
> ad->antic_expire make any problem?
> The related source code is quoted blow:
> 
> 	if (ad->antic_status == ANTIC_OFF || !ad->ioc_finished)
> 		delay = 0;
> 	else
> 		delay = ((jiffies - ad->antic_start) * 1000) / HZ;

antic_start is in jiffies, the difference is here multiplied by 1000 and
divided by HZ to turn it into msecs. so delay is in msecs.

-- 
Jens Axboe


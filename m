Return-Path: <linux-kernel-owner+w=401wt.eu-S1751604AbXB1EpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbXB1EpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 23:45:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbXB1EpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 23:45:05 -0500
Received: from mail.cse.ohio-state.edu ([164.107.123.5]:44538 "EHLO
	cse.ohio-state.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbXB1EpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 23:45:04 -0500
X-Greylist: delayed 1343 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Feb 2007 23:45:04 EST
Message-ID: <45E5038F.1090200@cse.ohio-state.edu>
Date: Tue, 27 Feb 2007 23:22:39 -0500
From: Xiaoning Ding <dingxn@cse.ohio-state.edu>
User-Agent: Thunderbird 1.5.0.9 (X11/20061215)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: a bug in AS scheduler?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am reading the source code AS scheduler in 2.6.18(as-ioscheduler.c).
In function as_close_req, variable delay is in millisecond, while
ad->antic_expire is in jiffies. Doesn't the comparison of delay and
ad->antic_expire make any problem?
The related source code is quoted blow:

	if (ad->antic_status == ANTIC_OFF || !ad->ioc_finished)
		delay = 0;
	else
		delay = ((jiffies - ad->antic_start) * 1000) / HZ;

	if (delay == 0)
		delta = 8192;
	else if (delay <= 20 && delay <= ad->antic_expire)
		delta = 8192 << delay;
	else
		return 1;


Xiaoning

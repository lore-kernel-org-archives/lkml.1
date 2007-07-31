Return-Path: <linux-kernel-owner+w=401wt.eu-S1764078AbXGaVUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764078AbXGaVUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565AbXGaVUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:20:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120AbXGaVUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:20:12 -0400
Message-ID: <46AFA78A.9010904@redhat.com>
Date: Tue, 31 Jul 2007 17:20:10 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: pm_trace displays the wrong time from the RTC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When resuming, systems print this when booted on 07/31/07:

Date: 06/31/107

/drivers/base/power/trace.c::read_magic_time():
114	get_rtc_time(&time);
115	printk("Time: %2d:%02d:%02d Date: %02d/%02d/%02d\n",
116		time.tm_hour, time.tm_min, time.tm_sec,
117		time.tm_mon, time.tm_mday, time.tm_year);

include/asm-generic/rtc.h:
102         /*
103          * Account for differences between how the RTC uses the values
104          * and how they are defined in a struct rtc_time;
105          */
106         if (time->tm_year <= 69)
107                 time->tm_year += 100;
108 
109         time->tm_mon--;


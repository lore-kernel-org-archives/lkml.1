Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbYH1Ilo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbYH1Ilo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 04:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbYH1Ilh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 04:41:37 -0400
Received: from relay5.mail.uk.clara.net ([80.168.70.185]:48644 "EHLO
	relay5.mail.uk.clara.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYH1Ilg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 04:41:36 -0400
Message-ID: <48B5723C.4020705@onelan.com>
Date: Wed, 27 Aug 2008 16:26:52 +0100
From: Simon Farnsworth <simon.farnsworth@onelan.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Joe Korty <joe.korty@ccur.com>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] printk timestamp post-boot suppression
References: <20080827151613.GA10325@tsunami.ccur.com>
In-Reply-To: <20080827151613.GA10325@tsunami.ccur.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Clara-Relay: Message sent using Claranet Relay Service using auth code: simon.farnsworth@onelan.co.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Korty wrote:
> Suppress printk timestamping after system boot.
> 
> The timestamp printk prefix seems most useful during boot,
> where it easily shows where the boot sequence is spending
> its time.
> 
It's also very useful while the system is running. We've had problems
with systems where the HDD or libata was "hiccuping" and stalling the
entire system for 30 seconds; our logs were useless, as syslog was
timestamping with the timestamp *after* the stall ended (as that was
when it received the message), and dmesg had no timestamps.

In this case, our problem ran away and hid when we turned on printk
timestamps, but if it recurred, we'd want the timestamps available to
let us work out which operation was taking lots of time, without having
to rebuild the kernel.
-- 
Simon Farnsworth


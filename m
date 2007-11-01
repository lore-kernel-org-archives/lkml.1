Return-Path: <linux-kernel-owner+w=401wt.eu-S1760963AbXKAP3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760963AbXKAP3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbXKAP3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:29:38 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:57013 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbXKAP3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:29:37 -0400
Date: Thu, 1 Nov 2007 15:29:14 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: linux-kernel@vger.kernel.org
Subject: CLOCK_TICK_RATE in NTP code
Message-ID: <20071101152914.GA19732@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/time/ntp.c contains the following piece of code:

#define CLOCK_TICK_OVERFLOW     (LATCH * HZ - CLOCK_TICK_RATE)
#define CLOCK_TICK_ADJUST       (((s64)CLOCK_TICK_OVERFLOW * NSEC_PER_SEC) / \
                                        (s64)CLOCK_TICK_RATE)

static void ntp_update_frequency(void)
{
        u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
                                << TICK_LENGTH_SHIFT;
        second_length += (s64)CLOCK_TICK_ADJUST << TICK_LENGTH_SHIFT;
        second_length += (s64)time_freq << (TICK_LENGTH_SHIFT - SHIFT_NSEC);

        tick_length_base = second_length;

        do_div(second_length, HZ);
        tick_nsec = second_length >> TICK_LENGTH_SHIFT;

        do_div(tick_length_base, NTP_INTERVAL_FREQ);
}

So it uses CLOCK_TICK_RATE which on many systems but not all is defined to
the i8253 input clock.  But timekeeping on anything remotely modern makes
little use of the i8253 so I wonder the intent was here.

  Ralf

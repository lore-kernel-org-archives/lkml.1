Return-Path: <linux-kernel-owner+w=401wt.eu-S1030637AbXBGQOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030637AbXBGQOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 11:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161357AbXBGQOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 11:14:05 -0500
Received: from www.osadl.org ([213.239.205.134]:32859 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030637AbXBGQOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 11:14:04 -0500
Subject: Re: posix-timers overrun broken?
From: Thomas Gleixner <tglx@linutronix.de>
To: Milan Svoboda <msvoboda@ra.rockwell.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <OFA77229BB.3038F286-ONC125727B.0048DC3E-C125727B.004AA20A@ra.rockwell.com>
References: <OFA77229BB.3038F286-ONC125727B.0048DC3E-C125727B.004AA20A@ra.rockwell.com>
Content-Type: text/plain
Date: Wed, 07 Feb 2007 17:14:14 +0100
Message-Id: <1170864854.3657.23.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-07 at 14:36 +0100, Milan Svoboda wrote:
> But if the next interrupt arrives before function collect_signal is called 
> to actually deliver the
> siginfo_t to userspace, the si.overrun is cleared in posix_timer_event and 
> we have just forgotten
> one overrun...
> 
> Am I wrong?

Yes. posix_timer_event() is only called when the timer expires the first
time. When the signal has been queued, the timer is not rearmed and the
overrun is calculated in the actual signal delivery path, which calls
do_schedule_next_timer().

	tglx



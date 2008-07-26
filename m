Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbYGZRze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbYGZRze (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 13:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYGZRz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 13:55:27 -0400
Received: from mx0.towertech.it ([213.215.222.73]:58562 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751946AbYGZRz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 13:55:26 -0400
Date: Sat, 26 Jul 2008 19:55:21 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Tomas Janousek <tomi@nomi.cz>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] rtc-dev: stop periodic interrupts on device release
Message-ID: <20080726195521.36d4d48c@i1501.lan.towertech.it>
In-Reply-To: <20080726154617.GA5613@notes.lisk.in>
References: <20080726154617.GA5613@notes.lisk.in>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008 16:46:17 +0100
Tomas Janousek <tomi@nomi.cz> wrote:

> Solves http://bugzilla.kernel.org/show_bug.cgi?id=11127
> 
> The old rtc.c driver did it, some drivers (like rtc-sh) do it in their release
> function too, but rtc-cmos does not -- because it provides the irq_set_state
> op -- so the rtc framework itself should care about it. This patch makes it do
> so.
> 
> I am aware that some drivers, like rtc-sh, handle userspace PIE sets in their
> ioctl op, exporting the irq_set_state op at the same time. The logic in
> rtc_irq_set_state should make sure it doesn't matter and the driver should not
> need to care stopping periodic interrupts in its release routine any more.
> I did not look at other drivers though.

 I'm not sure this is appropriate. sometimes the PIE is used to control
 external hardware and it doesn't make sense to have an application that's
 always open to handle that. 

 Any app should be responsible to release what it has allocated, if appropriate,
 and not rely on someone else to do on his behalf.
 

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it


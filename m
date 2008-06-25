Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbYFYI53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbYFYI53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 04:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYFYI5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 04:57:20 -0400
Received: from mx0.towertech.it ([213.215.222.73]:36469 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751085AbYFYI5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 04:57:19 -0400
Date: Wed, 25 Jun 2008 10:57:17 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: david-b@pacbell.net, lkml <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jonathan Corbet <corbet@lwn.net>,
       akpm@linux-foundation.org
Subject: Re: [rtc-linux] [PATCH] rtc: remove BKL for ioctl()
Message-ID: <20080625105717.2d9f30b2@i1501.lan.towertech.it>
In-Reply-To: <200806221955.42597.david-b@pacbell.net>
References: <200806221955.42597.david-b@pacbell.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2008 19:55:42 -0700
David Brownell <david-b@pacbell.net> wrote:

> Remove implicit use of BKL in ioctl() from the RTC framework.
> 
> Instead, the rtc->ops_lock is used.  That's the same lock that already
> protects the RTC operations when they're issued through the exported
> rtc_*() calls in drivers/rtc/interface.c ... making this a bugfix, not
> just a cleanup, since both ioctl calls and set_alarm() need to update
> IRQ enable flags and that implies a common lock (which RTC drivers as
> a rule do not provide on their own).
> 
> A new comment at the declaration of "struct rtc_class_ops" summarizes
> current locking rules.  It's not clear to me that the exceptions listed
> there should exist ... if not, those are pre-existing problems which can
> be fixed in a patch that doesn't relate to BKL removal.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>


 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it


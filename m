Return-Path: <linux-kernel-owner+w=401wt.eu-S1761517AbZEOFp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761517AbZEOFp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 01:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757223AbZEOFpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 01:45:49 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:46203 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756143AbZEOFpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 01:45:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=erDIy1RGSlnjjFO0O+HoZtMIXVGBsgUXwXw87e+uyPb/sBJoIYBVk/VunIVkGOC7Hy+1wewt07L7qOrZzNCqknbTV5YZiWUBMXBcuueK9bIKY/mYKJ/q73Zdtgcoc3eFXuh6Xw33dZEmNhzl2YDfR++DS73eps5lQJwBnHNvImQ=  ;
X-YMail-OSG: p4uQgtgVM1kMG4qRlFR4Qa3Aq1QywuWFMu5AuVevhoyD0UyvSo5iAJXy9tgRmMpbXfJLpEKA.OZASAGfA2oV0No4rhU1Hx28LMsE0KN7.QXV6wXh.XeSjz1K5RR9LDfP40U4rMjaxelTV3.t3qYjuuucNPmnqwWt1jxhEdekdEYH8d9W8pyagu_aP9pprHwdFufVn9fzmJrKp7YWyGkQyokAx_o5kxy8DSi_.LNRHDp3_smhBa7w9hjqUhOkcNg2SdjfJxAVGBcpY6I-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: pm-susend on 2.6.30-rc5
Date: Thu, 14 May 2009 22:45:48 -0700
User-Agent: KMail/1.9.10
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <43e72e890905131833k291c8720r4045e9e497430b40@mail.gmail.com>
In-Reply-To: <43e72e890905131833k291c8720r4045e9e497430b40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905142245.49150.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 May 2009, Luis R. Rodriguez wrote:
> When trying suspend on 2.6.30-rc5 I get the following WARN and also
> cannot use my write to my file system. I cannot even reboot:
> 
> mcgrof@pogo ~ $ sudo reboot
> sudo: unable to execute /sbin/reboot: Success
> mcgrof@pogo ~ $ echo $?
> 127
> 
> Granted, I've never tried to suspend on this box, its a development
> desktop, but still think you'd like to know about it. The actual WARN
> in question is:
> 
>         /* Warning on suspend means the RTC alarm period needs to be
>          * larger -- the system was sooo slooowwww to suspend that the
>          * alarm (should have) fired before the system went to sleep!
>          *
>          * Warning on either suspend or resume also means the system
>          * has some performance issues.  The stack dump of a WARN_ON
>          * is more likely to get the right attention than a printk...
>          */
>         WARN(msec > (TEST_SUSPEND_SECONDS * 1000), "Component: %s\n", label);

None of that was supposed to be executing *except* during
(a) initial boot, when (b) the command line parameter was
set to enable that test during boot ... see test_suspend().

If we can't enter standby/suspend/hibernate then, it's
either a regression or a bug to fix; ergo the warning.

Clearly that's been changed at some point, and this problem
relates to those changes.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbYJ0UT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbYJ0UT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbYJ0UTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:19:38 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:24135 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753092AbYJ0UTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:19:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=EsmNQY/3N0DTR3dRHLydcjp/P+8s21RJxX1VWcm9Ecg0tSRru9Ps3nsDuMsYQIh5ltSvt+LhPqSjaEgfyW3QZ5iF/4hLnUrgF+GH7ibylih5/YgrA1bTKpx/512mnFfQmU26Qe8Dl9Vkmk04QTGFx6D/+Ncpa/aD4K4obZx8kqE=  ;
X-YMail-OSG: AGiwUFwVM1nGjM8fJZUDJJ0ZUwmYj.960sngXPbUtifD0buXI66DL5DwtEIBujW_e.pJK9l9lpk1KSM41yB04W8EzgQF1r8U8EkYXnTSFxINnqj.wJqhzJmKGygEDuwAuEPTrQs5je_wT6ZYVGr6ra4WqELBm.H.7PzcGCYXx8Go0yzpC_igl5ZzIDOM
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [rtc-linux] [PATCH 2/2] rtc: rtc-wm8350: Add support for WM8350 RTC
Date: Mon, 27 Oct 2008 13:19:34 -0700
User-Agent: KMail/1.9.10
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1225121905-23782-1-git-send-email-broonie@opensource.wolfsonmicro.com> <200810271303.21634.david-b@pacbell.net> <20081027200900.GA31757@rakim.wolfsonmicro.main>
In-Reply-To: <20081027200900.GA31757@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810271319.35256.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 October 2008, Mark Brown wrote:
> On Mon, Oct 27, 2008 at 01:03:21PM -0700, David Brownell wrote:
> > On Monday 27 October 2008, Alessandro Zummo wrote:
> > >  (and a detailed checklist at http://groups.google.com/group/rtc-linux/web/checklist )
> 
> > Also:  rtc_ops.ioctl() method should only handle RTC_{AIE,UIE}_{ON,OFF},
> > since the other standard ioctls have rtc_ops equivalents.
> 
> > (This code is fine in both respects.  Though since I've received three
> > copies of the driver since it was merged to MM, maybe I missed something.)
> 
> Unfortunately I added the __devexit_p() annotation in response to
> Alessandro's comments.  I'll remove it again,

No, don't -- that's why I said "this code is fine..." !!

You're not using platform_driver_probe(), so it's appropriate to
use the __devexit() route.


> other than that all that's 
> changed is a tweak to the module description and Andrew's change to use
> schedule_timeout_uninterruptible().
> 
> How should these drivers be merged?

Andrew is the keeper of the RTC patch queue, so I suggest you issue
one patch against the two in MM:

	rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
	rtc-rtc-wm8350-add-support-for-wm8350-rtc-fix.patch

That would probably cause the least amount of extra work for Andrew.

- Dave

 



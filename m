Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbZHXVuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbZHXVuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbZHXVuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:50:05 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:41055 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753646AbZHXVuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:50:04 -0400
Message-ID: <4A930AE0.2070007@euromail.se>
Date: Mon, 24 Aug 2009 23:49:20 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: nicolas@boichat.ch, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: applesmc: restore keyboard backlight on resume
References: <1250976832-9801-1-git-send-email-rydberg@euromail.se> <20090824140717.e7011b8c.akpm@linux-foundation.org>
In-Reply-To: <20090824140717.e7011b8c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1MfhPo-0007sC-5B.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1MfhPo-0007sC-5B a5d643df28eaa78e43da949cb245504c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 22 Aug 2009 23:33:52 +0200
> "Henrik Rydberg" <rydberg@euromail.se> wrote:
> 
>> On resume from suspend, the driver currently resets the logical
>> state as if it was brought up from halt. This patch uses the
>> dev_pm_ops.resume method to synchronize the hardware with the
>> memorized logical state, bringing back the backlight to the level
>> prior to suspend.
> 
> What are the runtime effects of this change?

The patch has zero impact on a running system, only suspend/resume
behavior is affected.

Precondition: Suspend computer with keyboard backlight brightness
greater than zero.

Before patch: On resume, the backlight stays off.

After patch: On resume, the backlight is set to the brightness prior to
suspend.

There is one side-effect of the patch: the accelerometer no longer
re-calibrates on resume, but keeps the calibration from before suspend.
I consider this a good change, but it is after all a change.

Henrik


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbZHXXsC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbZHXXsC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 19:48:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbZHXXr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 19:47:58 -0400
Received: from csmtp3.one.com ([195.47.247.213]:40847 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbZHXXr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 19:47:58 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Aug 2009 19:47:58 EDT
Message-ID: <4A932456.9000500@bitmath.org>
Date: Tue, 25 Aug 2009 01:37:58 +0200
From: Henrik Rydberg <rydberg@bitmath.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Henrik Rydberg <rydberg@euromail.se>, nicolas@boichat.ch,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: applesmc: restore keyboard backlight on resume
References: <1250976832-9801-1-git-send-email-rydberg@euromail.se> <20090824140717.e7011b8c.akpm@linux-foundation.org>
In-Reply-To: <20090824140717.e7011b8c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
> 

My apologies, the patch has two flaws.

1) For macbook models without keyboard backlight, the resume function
will fail internally, presumably resulting in a small unnecessary delay.

2) The accelerometer does not reset properly after hibernation.

Please drop this patch from -mm, I am sending a corrected patch
with a slightly different title. Sorry about this.

Henrik

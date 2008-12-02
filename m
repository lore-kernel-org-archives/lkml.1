Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbYLBSxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbYLBSxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 13:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYLBSxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 13:53:45 -0500
Received: from rtr.ca ([76.10.145.34]:46393 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbYLBSxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 13:53:44 -0500
Message-ID: <4935847C.6090203@rtr.ca>
Date: Tue, 02 Dec 2008 13:54:52 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>, Len Brown <lenb@kernel.org>,
       Alessandro Zummo <a.zummo@towertech.it>,
       David Brownell <david-b@pacbell.net>,
       lkml <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
       linux-acpi@vger.kernel.org
Subject: Re: PATCH: /proc/acpi/alarm: handle day-of-month wraparound on	readback
References: <200806222042.13929.david-b@pacbell.net> <4934176F.6080900@rtr.ca> <4934188E.6080701@rtr.ca> <20081202102925.GA3194@dose.home.local>
In-Reply-To: <20081202102925.GA3194@dose.home.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tino Keitel wrote:
> On Mon, Dec 01, 2008 at 12:02:06 -0500, Mark Lord wrote:
>> Mark Lord wrote:
>>> Fix month wrap issue with readback from /proc/acpi/alarm
>>> This bug has been around *forever*.
>>>
>>> $ echo '2008-12-01 10:36:20' > /proc/acpi/alarm
>>> $ cat /proc/acpi/alarm
>>> 2008-11-01 10:36:20
>>>
>>> Note how the readback above shows the month incorrectly.
>>> But with this patch applied, it shows the correct month (12).
>> ..
>>
>> I should add, that the above test requires that the alarm
>> be set for any day of the *next* month from the current month.
>> My MythTV box does a readback test any time it programs a wakeup,
>> and noticed the bug over this past weekend (2008-11-30).
> 
> Why not just use the new RTC drivers and /sys/class/rtc/rtc0/wakealarm?
..

That question has nothing to do with fixing the bug in
the /proc/acpi/alarm code.  The bug is still there whether
I personally use a different mechanism or not!  :)

But in answer to your question, the new RTC drivers *also* fail
for some other reason.  They did work up until the HPET integration
(back in 2.6.26 ?), but have not worked since.

My MythTV box always tries the new ones, and if the readback test
fails to agree with what was attempted, it then falls back to
the old yet more reliable /proc/acpi/alarm.

I haven't really had time to find the exact breakage point and patch it
in the new RTC code yet (I put about 10 hours into it back then,
with no useful result), but the old code does have a useful fix.

Thus this thread.

Cheers

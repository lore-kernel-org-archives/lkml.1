Return-Path: <linux-kernel-owner+w=401wt.eu-S932164AbZD1IBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbZD1IBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759530AbZD1IBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:01:07 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:49315 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758342AbZD1IBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:01:06 -0400
Message-ID: <49F6B782.8030205@euromail.se>
Date: Tue, 28 Apr 2009 10:00:02 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] input: Add a detailed multi-touch finger data report
 protocol (rev2)
References: <266E0723-B689-4472-8A2F-D93FC6819E04@gmail.com>
In-Reply-To: <266E0723-B689-4472-8A2F-D93FC6819E04@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.194.102
X-Scan-Result: No virus found in message 1LyiFQ-0000Gq-7c.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1LyiFQ-0000Gq-7c 47b8c782bc1d28f8ad406e78683b2872
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> Hi Henrik,
> 
> On Wed, Jan 28, 2009 at 11:23:49AM +0100, Henrik Rydberg wrote:
>> +
>> +#define ABS_MT_TOUCH        0x30    /* Diameter of touching circle */
>> +#define ABS_MT_TOUCH_MAJOR    0x30    /* Major axis of touching
>> ellipse */
> 
> It looks like we are overriding the same event code to trasnmit 2
> slightly different kinds of data. I Am concerned that people would get
> confused, maybe we should get rid of ABS_MT_TOUCH and either require
> drvices always transmit ABS_MT_TOUCH_MAJOR and ABS_MT_TOUCH_MINOR or
> document that for curcular objects ABS_MT_TOUCH_MINOR may be omitted.

Done.

>> @@ -744,6 +758,14 @@ struct input_absinfo {
>> #define BUS_ATARI        0x1B
>>
>> /*
>> + * MT_TOOL types
>> + */
>> +#define MT_TOOL_FINGER        0
>> +#define MT_TOOL_PEN        1
>> +#define MT_TOOL_MAX        9
>> +#define MT_TOOL_CNT        (MT_TOOL_MAX + 1)
> 
> MT_TOOL_FINGER/MT_TOOL_PEN are documented values of ABS_MT_TOOL_TYPE, so
> I don't understand why we need MT_TOOL_MAX/MT_TOOL_CNT definitions.

Ah! It is a remnant from a much earlier version which used a separate MT
event type. It slipped through, my bad. Remedied. Thanks.

Revision three of the patch has been sent.

Cheers,
Henrik


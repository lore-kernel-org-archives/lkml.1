Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbZC3Ncp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbZC3Ncp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 09:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbZC3Ncg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 09:32:36 -0400
Received: from rtr.ca ([76.10.145.34]:59677 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbZC3Ncg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 09:32:36 -0400
Message-ID: <49D0C9F1.6020006@rtr.ca>
Date: Mon, 30 Mar 2009 09:32:33 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: ivtv-devel@ivtvdriver.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       v4l-dvb-maintainer@linuxtv.org, g.liakhovetski@gmx.de,
       video4linux-list@redhat.com
Subject: Re: [ivtv-devel] 2.6.29: ivtv-vbi.c: divide-by-zero in compress_sliced_buf()
References: <49D03596.8030802@rtr.ca> <200903301100.31611.hverkuil@xs4all.nl> <49D0C936.8090407@rtr.ca>
In-Reply-To: <49D0C936.8090407@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Hans Verkuil wrote:
>> On Monday 30 March 2009 04:59:34 Mark Lord wrote:
>>> The changes to line_size in 2.6.29 now cause
>>> attempts to record from my PVR250 cards (MythTV)
>>> to die with a divide by zero error in ivtv-vbi.c.
>>>
>>> The value of "line_size" in compress_sliced_buf() is zero.
>>
>> Weird. That should never be zero. Can you mail me the ivtv 
>> initialization log from dmesg? I need the bit between 'ivtv: Start 
>> initialization' and 'ivtv: End initialization'.
> ..
> 
> Sent.
..

For what it's worth, I did try patching that function to detect
a line_size of zero, and replace it on the fly with a more likely value.
This prevented the crash, but the recorded video was very dark, as if
colour controls had not be initialized.  That could be another clue.

Cheers

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762286AbYEEVEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762286AbYEEVEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757579AbYEEVEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:04:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42214 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048AbYEEVEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:04:20 -0400
Date: Mon, 5 May 2008 17:04:17 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Robin Holt <holt@sgi.com>
cc: Alistair John Strachan <alistair@devzero.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc1
In-Reply-To: <20080504160904.GF19717@sgi.com>
Message-ID: <Pine.LNX.4.64.0805051656180.3218@bombadil.infradead.org>
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org>
 <200805032253.22765.alistair@devzero.co.uk> <20080504123008.GE19717@sgi.com>
 <200805041456.14415.alistair@devzero.co.uk> <20080504160904.GF19717@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alistair,

Sorry for not answering earlier, I got some days off (I still didn't read 
all messages from you - I'm flooded of messages here).

>> I have DVB_CORE=n and VIDEO_DEV=y. VIDEO_DEV is:
>>
>> config VIDEO_DEV
>>         tristate "Video For Linux"
>>
>> So if you enable Video For Linux, the tuner-core is automatically built, even
>> if no tuners are selected? Surely that's wrong..
>
> That is probably correct.  Video For Linux is used for capturing video
> streams.  The fact that you can get this invalid config to fail to build
> should be reported to the v4l folks and let them fix it up.

Yes, this is correct, if you select a board that supports tuner (for 
example, bttv, or cx88).

The error is that most tuners are dependent of I2C. The right fix seems to 
do this:


config MEDIA_TUNER
         tristate
         default (DVB_CORE || VIDEO_DEV) && I2C
         depends on (DVB_CORE || VIDEO_DEV) && I2C



>
> VIDEO FOR LINUX
> P:      Mauro Carvalho Chehab
> M:      mchehab@infradead.org
> M:      v4l-dvb-maintainer@linuxtv.org
> L:      video4linux-list@redhat.com
> W:      http://linuxtv.org
> T:      git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
> S:      Maintained
>
>
> Thanks,
> Robin
>

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org

Return-Path: <linux-kernel-owner+w=401wt.eu-S965010AbXBVBOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965010AbXBVBOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 20:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965014AbXBVBOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 20:14:32 -0500
Received: from thing.hostingexpert.com ([67.15.235.34]:40232 "EHLO
	thing.hostingexpert.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965010AbXBVBOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 20:14:30 -0500
Message-ID: <45DCEE68.9000906@linuxtv.org>
Date: Wed, 21 Feb 2007 20:14:16 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robert Hancock <hancockr@shaw.ca>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [patch 01/21] V4L: cx88: Fix lockup on suspend
References: <20070221012758.925122216@mini.kroah.org> <20070221013634.GB30227@kroah.com> <45DCEB16.2070907@redhat.com>
In-Reply-To: <45DCEB16.2070907@redhat.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - thing.hostingexpert.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linuxtv.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> Greg KH wrote:
>> -stable review patch.  If anyone has any objections, please let us know.
>>
>> ------------------
>> Suspending with the cx88xx module loaded causes the system to lock up
>> because the cx88_audio_thread kthread was missing a try_to_freeze()
>> call, which caused it to go into a tight loop and result in softlockup
>> when suspending. Fix that.
>>
>> (cherry picked from commit a96afb3e9428f2e7463344f12dbc85faf08e2e09)
>>
>> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
>> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>>
>> ---
>>  drivers/media/video/cx88/cx88-tvaudio.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> --- linux-2.6.19.4.orig/drivers/media/video/cx88/cx88-tvaudio.c
>> +++ linux-2.6.19.4/drivers/media/video/cx88/cx88-tvaudio.c
>> @@ -38,6 +38,7 @@
>>  #include <linux/module.h>
>>  #include <linux/moduleparam.h>
>>  #include <linux/errno.h>
>> +#include <linux/freezer.h>
>>  #include <linux/kernel.h>
>>  #include <linux/slab.h>
>>  #include <linux/mm.h>
>> @@ -974,6 +975,7 @@ int cx88_audio_thread(void *data)
>>  		msleep_interruptible(1000);
>>  		if (kthread_should_stop())
>>  			break;
>> +		try_to_freeze();
>>  
>>  		/* just monitor the audio status for now ... */
>>  		memset(&t, 0, sizeof(t));
>>
> 
> drivers/media/video/cx88/cx88-tvaudio.c:41:27: error: linux/freezer.h: No such file or directory
> make[4]: *** [drivers/media/video/cx88/cx88-tvaudio.o] Error 1
> make[3]: *** [drivers/media/video/cx88] Error 2
> make[3]: *** Waiting for unfinished jobs....
> 

Yikes...  This one shouldn't have been sent to 2.6.18.y nor 2.6.19.y ... tree-mixup :-/

Please drop this one.  Thanks, Chuck.

Sorry about that...

-Mike Krufky

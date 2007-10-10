Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbXJLD5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbXJLD5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 23:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbXJLD4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 23:56:54 -0400
Received: from host06.hostingexpert.com ([216.80.70.60]:49148 "EHLO
	host06.hostingexpert.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502AbXJLD4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 23:56:53 -0400
X-Greylist: delayed 171494 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2007 23:56:53 EDT
Message-ID: <470C5294.8060502@linuxtv.org>
Date: Wed, 10 Oct 2007 00:18:28 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Jiri Slaby <jirislaby@gmail.com>, video4linux-list@redhat.com,
       daniel@qanu.de, linux-kernel@vger.kernel.org, holger@qanu.de,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH 3/3] V4L: cinergyT2,	remove bad usage
 of ERESTARTSYS
References: <24841282012868130110@pripojeni.net> <1191979260.5492.32.camel@gaivota>
In-Reply-To: <1191979260.5492.32.camel@gaivota>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host06.hostingexpert.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linuxtv.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> Hi Jiri,
>
> Em Seg, 2007-10-08 às 13:41 +0100, Jiri Slaby escreveu:
>   
>> cinergyT2, remove bad usage of ERESTARTSYS
>>
>> test of cinergyt2->disconnect_pending doesn't ensure pending signal and so
>> ERESTARTSYS would reach userspace, which is not permitted. Change it to
>> EAGAIN
>>
>>     
>
> checkpatch.pl is complaining about your changeset:
>
> do not use assignment in if condition
> #82: FILE: drivers/media/dvb/cinergyT2/cinergyT2.c:492:
> +     if ((err = mutex_lock_interruptible(&cinergyt2->wq_sem)))
>
> do not use assignment in if condition
> #86: FILE: drivers/media/dvb/cinergyT2/cinergyT2.c:495:
> +     if ((err = mutex_lock_interruptible(&cinergyt2->sem)))
>
> do not use assignment in if condition
> #133: FILE: drivers/media/dvb/cinergyT2/cinergyT2.c:1036:
> +     if ((err = mutex_lock_interruptible(&cinergyt2->wq_sem)))
>
> do not use assignment in if condition
> #137: FILE: drivers/media/dvb/cinergyT2/cinergyT2.c:1039:
> +     if ((err = mutex_lock_interruptible(&cinergyt2->sem)))

Is this illegal as per kernel codingstyle?  I could understand if we may
want to avoid this sort of thing for the sake of code readability, but
this seems 100% proper to me, especially considering that we're simply
trying to catch an error return code.

One of the things that I really enjoy about the c programming language
is the fact that you can string many operations together into a single
statement through the use of logic.  I hate the thought of a patch being
nacked because of the above.  :-/

If this is indeed kernel codingstyle, then IMHO, we should let it slide
for catching error return codes.

Regards,

Mike Krufky

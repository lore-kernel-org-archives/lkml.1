Return-Path: <linux-kernel-owner+w=401wt.eu-S1761537AbYEST2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761537AbYEST2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 15:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757779AbYEST1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 15:27:54 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55919 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246AbYEST1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 15:27:53 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4831D484.10505@s5r6.in-berlin.de>
Date: Mon, 19 May 2008 21:27:00 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH, RFC] Char dev BKL pushdown v2
References: <19845.1211148908@vena.lwn.net> <4831BD08.6030600@s5r6.in-berlin.de>
In-Reply-To: <4831BD08.6030600@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Jonathan Corbet wrote:
>>  drivers/ieee1394/dv1394.c                    |    6 +++-
>>  drivers/ieee1394/raw1394.c                   |    3 ++
>>  drivers/ieee1394/video1394.c                 |   18 +++++++++---
> ...
>>       ieee1394: cdev lock_kernel() pushdown
> 
> I have yet to look at these drivers in detail whether they need BKL or 
> not.  They likely don't.

video1394 needs it to serialize module init vs. open.  The race 
condition there can be prevented by splitting hpsb_register_highlevel() 
into an _init and a _register function.  I will follow up with a patch.

dv1394 and raw1394 do not need the BKL in their open() methods AFAICS.
-- 
Stefan Richter
-=====-==--- -=-= =--==
http://arcgraph.de/sr/

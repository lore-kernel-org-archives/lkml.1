Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230Ab0A0OVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab0A0OVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240Ab0A0OVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:21:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:13696 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab0A0OVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:21:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=VtePmD8ntBLYGZGxiMuRQCE9g9a38c2ZCpW5VTpI+bcHBXytQWj8qTUHtLgZSk4EEv
         OzP3b0oE3AufjiHYchPzrQnO4wHZDu8GW93ZOB6ln32AEKMWBB8eMARRcKT4Mv1pc/5i
         z28CwZTRNKdm9E//mEMYwtg8zvplGiGC7ajgc=
Message-ID: <4B604BD6.1010205@gmail.com>
Date: Wed, 27 Jan 2010 15:21:10 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, bzolnier@gmail.com, jens.axboe@oracle.com,
       marcin.slusarz@gmail.com, shemminger@vyatta.com
Subject: Re: + drivers-block-floppyc-use-pr_level.patch added to -mm tree
References: <201001270037.o0R0bN6S032517@imap1.linux-foundation.org>	 <4B600806.4010003@gmail.com> <1264601340.14552.55.camel@Joe-Laptop.home>
In-Reply-To: <1264601340.14552.55.camel@Joe-Laptop.home>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 03:09 PM, Joe Perches wrote:
> On Wed, 2010-01-27 at 10:31 +0100, Jiri Slaby wrote:
>> On 01/27/2010 01:37 AM, akpm@linux-foundation.org wrote:
>>> @@ -687,9 +687,7 @@ static void __reschedule_timeout(int dri
>>>  		fd_timeout.expires = jiffies + UDP->timeout;
>>>  	add_timer(&fd_timeout);
>>>  	if (UDP->flags & FD_DEBUG) {
>>> -		DPRINT("reschedule timeout ");
>>> -		printk(message, marg);
>>> -		printk("\n");
>>> +		DPRINT("reschedule timeout %s %d\n", message, marg);
>>
>> This is wrong.
> 
> I disagree.

Then you need to document it in the changelog. The patch does something
completely different to what is stated in the changelog.

> It does add an always output decimal value to the DPRINT
> instead of a mostly mismatched format and argument
> 	printk(message, marg).
> 
> Previous single matched output use of message/marg:
> 
> -	reschedule_timeout(MAXTIMEOUT, "request done %d", uptodate);
> +	reschedule_timeout(MAXTIMEOUT, "request done", uptodate);
> 
> vs now:
> 
> $ grep reschedule_timeout drivers/block/floppy.c
> static void __reschedule_timeout(int drive, const char *message, int marg)
> static void reschedule_timeout(int drive, const char *message, int marg)
> 	__reschedule_timeout(drive, message, marg);
> 	__reschedule_timeout(drive, "lock fdc", 0);
> 	reschedule_timeout(current_reqD, "floppy start", 0);
> 	reschedule_timeout(MAXTIMEOUT, "do wakeup", 0);
> 	reschedule_timeout(MAXTIMEOUT, "request done", uptodate);
> 		reschedule_timeout(current_reqD, "redo fd request", 0);
> 	reschedule_timeout(MAXTIMEOUT, "floppy init", MAXTIMEOUT);

So if I understand correctly, it now prints the third argument every time.

-- 
js

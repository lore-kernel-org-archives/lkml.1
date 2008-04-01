Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbYDAJyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbYDAJyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbYDAJyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 05:54:05 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:2928 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbYDAJyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 05:54:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=REST2nyv1nCPCxVzKaSesIGcD6fJKoN9FMeRiyC/lXxWD88SqnkIA0xiiq5mGqeVsWAawjmkV+6xrB7u1XCJOP74ybBAdwRTqfxqURv0fpPdW2ZeHSPkznjnUUbgAe7GpgQOzZ/epScVc9fH2T9Sq6LQHvRWw2aL6f/fZjS7gGw=
Message-ID: <47F20631.7050308@gmail.com>
Date: Tue, 01 Apr 2008 11:53:53 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Char: ip2, fix sparse warnings
References: <20080328032449.cbc09f3b.akpm@linux-foundation.org>	<1206739124-3875-3-git-send-email-jirislaby@gmail.com> <20080331165718.0fb7c14e.akpm@linux-foundation.org>
In-Reply-To: <20080331165718.0fb7c14e.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> On Fri, 28 Mar 2008 22:18:43 +0100
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> Unlock two grabbed locks on some paths.
>>
>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>> ---
>>  drivers/char/ip2/i2lib.c |   10 ++++++----
>>  1 files changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/char/ip2/i2lib.c b/drivers/char/ip2/i2lib.c
>> index 618f5fe..1d5388c 100644
>> --- a/drivers/char/ip2/i2lib.c
>> +++ b/drivers/char/ip2/i2lib.c
[...]
>> @@ -1834,6 +1834,8 @@ i2StripFifo(i2eBordStrPtr pB)
>>  		default: // Neither packet? should be impossible
>>  			ip2trace (ITRC_NO_PORT, ITRC_SFIFO, 5, 1,
>>  				PTYPE_OF(pB->i2eLeadoffWord) );
>> +			write_unlock_irqrestore(&pB->read_fifo_spinlock,
>> +					bflags);
>>  
>>  			break;
>>  		}  // End of switch on type of packets
> 
> Your tree apparently has a sensible-looking write_unlock_irqrestore(),
> whereas mine has a stupid-looking WRITE_UNLOCK_IRQRESTORE().  How did this
> happen?

This was changed in the previous wrong patch, I'm preparing a correct one.

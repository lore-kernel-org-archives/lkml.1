Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbXKELYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbXKELYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 06:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbXKELYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 06:24:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:50875 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbXKELYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 06:24:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=WgxA23YNBTlvmPUNBrWEXBQIPC68XBVpADpTNtpEihqDp+tMzUNjpTZvG6cEMAnJcmwoq32fuVEzOg5ITYkGczocLS/ynwvwZRi+M3WAOfQJXQckYEuiM87R02J3wkiYnf3A90yePXW+YcfS+a+18SoEQDydygbX2Y6fjjklm7c=
Message-ID: <472EFD76.7000001@gmail.com>
Date: Mon, 05 Nov 2007 12:24:38 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jesper Nilsson <jesper.nilsson@axis.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRISv10 serial driver rewrite
References: <20071102093432.GD7621@axis.com> <472AFE4D.5030308@gmail.com> <20071105111839.GI7621@axis.com>
In-Reply-To: <20071105111839.GI7621@axis.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2007 12:18 PM, Jesper Nilsson wrote:
> On Fri, Nov 02, 2007 at 11:39:09AM +0100, Jiri Slaby wrote:
>> On 11/02/2007 10:34 AM, Jesper Nilsson wrote:
>>> @@ -4434,7 +3941,7 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
>>>  	if (tty_hung_up_p(filp) ||
>>>  	    (info->flags & ASYNC_CLOSING)) {
>>>  		if (info->flags & ASYNC_CLOSING)
>>> -			interruptible_sleep_on(&info->close_wait);
>>> +			wait_event_interruptible(info->close_wait, 0);
>> Aiee, this is nonsense, 0 will never be 1, only signal will stop this, use
>> completion instead.
> 
> True, I've changed it to use "!info->flags & ASYNC_CLOSING" condition
> for now, as this is a more non-intrusive patch.
> I will look at using completion later, at the same time as using

Aha, then the completion is a bad idea. Just
wait_event_interruptible(info->close_wait, !(info->flags & ASYNC_CLOSING));
as you proposed to use is fine (and you don't need the "if (info->flags &
ASYNC_CLOSING)" test one line above).

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbYGAJBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbYGAJBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 05:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbYGAJBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 05:01:13 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:27053 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbYGAJBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 05:01:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hvYfVqqo6n4mAsQM7UcREnOsHNiIu9Vkxn0SbZYW2wHBYjIpUQljO3sIRwOr64kK6Q
         ubiNeH4kh2Un5wHtOZ/U0thrpU9HyfqbBgYiCpRsvgE+TXXBCpWnWlnYLHqTTWRBR07L
         f1VKIxWexnD3IQu34hft/wcNr65yw3rsQ/agQ=
Message-ID: <4869F252.8040600@gmail.com>
Date: Tue, 01 Jul 2008 12:01:06 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Elias Oltmanns <eo@nebensachen.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Joe Peterson <joe@skyrush.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <87fxqurqpz.fsf@denkblock.local> <4869EFF2.7030807@davidnewall.com>
In-Reply-To: <4869EFF2.7030807@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Elias Oltmanns wrote:
>   
>> -			if (!L_NOFLSH(tty)) {
>> -				n_tty_flush_buffer(tty);
>> -				tty_driver_flush_buffer(tty);
>> -			}
>>  			if (L_ECHO(tty))
>>  				echo_char(c, tty);
>> -			if (tty->pgrp)
>> -				kill_pgrp(tty->pgrp, signal, 1);
>> +			isig(signal, tty, 0);
>>     
>
> My first reaction is that tty->pgrp must be null.  Perhaps the patch
> could be simplified...
>
>  			if (tty->pgrp)
>  				kill_pgrp(tty->pgrp, signal, 1);
> +			else
> +				isig(signal, tty, 0);
>
>
> Thoughts?
>   

isig has the same check, if it is NULL, isig won't deliver the signal
either:

if (tty->pgrp)
        kill_pgrp(tty->pgrp, sig, 1);

--Edwin


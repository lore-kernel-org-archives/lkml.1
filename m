Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbYGAJMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbYGAJMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 05:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbYGAJMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 05:12:44 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:47199 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753173AbYGAJMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 05:12:43 -0400
Message-ID: <4869F502.5030201@davidnewall.com>
Date: Tue, 01 Jul 2008 18:42:34 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
CC: Elias Oltmanns <eo@nebensachen.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Joe Peterson <joe@skyrush.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <87fxqurqpz.fsf@denkblock.local> <4869EFF2.7030807@davidnewall.com> <4869F252.8040600@gmail.com>
In-Reply-To: <4869F252.8040600@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Török Edwin wrote:
> David Newall wrote:
>   
>> Elias Oltmanns wrote:
>>   
>>     
>>> -			if (!L_NOFLSH(tty)) {
>>> -				n_tty_flush_buffer(tty);
>>> -				tty_driver_flush_buffer(tty);
>>> -			}
>>>  			if (L_ECHO(tty))
>>>  				echo_char(c, tty);
>>> -			if (tty->pgrp)
>>> -				kill_pgrp(tty->pgrp, signal, 1);
>>> +			isig(signal, tty, 0);
>>>     
>>>       
>> My first reaction is that tty->pgrp must be null.  Perhaps the patch
>> could be simplified...
>>
>>  			if (tty->pgrp)
>>  				kill_pgrp(tty->pgrp, signal, 1);
>> +			else
>> +				isig(signal, tty, 0);
>>
>>
>> Thoughts?
>>   
>>     
>
> isig has the same check, if it is NULL, isig won't deliver the signal
> either
>   

That is odd.  We did see the control-key echoed, so, other than not
flushing output, what's funcitonally different?

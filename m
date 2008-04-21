Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbYDUTGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbYDUTGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760189AbYDUTFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:05:43 -0400
Received: from smtp122.sbc.mail.re3.yahoo.com ([66.196.96.95]:43803 "HELO
	smtp122.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760159AbYDUTFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:05:42 -0400
X-YMail-OSG: orZOMn0VM1lGRx5fmNj8iD0H7JyL1y2pANx8z5SEW3b4dK7ZS61xS7BidYXlVD8fUFVF1XtVf2vT_CYhQSli9Njyi.EZF6VU1M9ajA--
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 21 Apr 2008 14:01:43 -0500
From: serge@hallyn.com
To: David <david@unsolicited.net>
Cc: serge@hallyn.com, casey@schaufler-ca.com, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morgan <morgan@kernel.org>
Subject: Re: 2.6.25 Kernel - Problems with capabilities
Message-ID: <20080421190143.GA23365@vino.hallyn.com>
References: <46016.36939.qm@web36608.mail.mud.yahoo.com> <480B7D72.7020503@unsolicited.net> <20080421000055.GA17510@vino.hallyn.com> <20080421080101.htzh4s03snescog4@unsolicited.net> <20080421183451.GA22071@vino.hallyn.com> <480CE167.8090907@unsolicited.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480CE167.8090907@unsolicited.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David (david@unsolicited.net):
> serge@hallyn.com wrote:
>>>
>>> /lib/libcap.so.1 -> libcap.so.1.92
>>>
>>> I guess that's 1.92 (should be the version shipped with SuSE 9.1).
>>>     
>>
>> Ok, thanks, then it's definately not what I was thinking.
>>
>> (Will wait to check out your strace)
>>   
> strace attached.
>
> Cheers
> David
>

...
> capget(0x20071026, 0, {, , })           = -1 EINVAL (Invalid argument)

This is odd.  libcap-1.x should be passing in 0x19980330.

Next, given the -EINVAL return value ntpd should be seeing a NULL result
from cap_get_proc() and exiting right there.

What version of ntpd is this?  (I must be looking at a wrong value, but
even so the fact that cap_get_proc()->capget() is using 0x20071026 for
version doesn't make sense)

> capset(0, 0, {CAP_NET_BIND_SERVICE|CAP_SYS_TIME, CAP_NET_BIND_SERVICE|CAP_SYS_TIME, CAP_NET_BIND_SERVICE|CAP_SYS_TIME}) = -1 EINVAL (Invalid argument)
> time(NULL)                              = 1208803493
> write(5, "21 Apr 19:44:53 ntpd[6118]: cap_"..., 92) = 92
> munmap(0x40022000, 4096)                = 0
> exit_group(-1)                          = ?
> Process 6118 detached


thanks,
-serge

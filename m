Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbYDUAFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbYDUAFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 20:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbYDUAEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 20:04:53 -0400
Received: from smtp101.sbc.mail.re2.yahoo.com ([68.142.229.104]:34640 "HELO
	smtp101.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751768AbYDUAEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 20:04:52 -0400
X-YMail-OSG: _.TdiBgVM1k50iwnY4TnP8NB4WMaLTI.yJDTBrYFU1enBctuPaBszYIhDapOs3AXH05mqtyN_0ymTqH_g36gAiWUMA0YDgszoEFF1Q--
X-Yahoo-Newman-Property: ymail-3
Date: Sun, 20 Apr 2008 19:00:55 -0500
From: serge@hallyn.com
To: David <david@unsolicited.net>
Cc: casey@schaufler-ca.com, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morgan <morgan@kernel.org>
Subject: Re: 2.6.25 Kernel - Problems with capabilities
Message-ID: <20080421000055.GA17510@vino.hallyn.com>
References: <46016.36939.qm@web36608.mail.mud.yahoo.com> <480B7D72.7020503@unsolicited.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480B7D72.7020503@unsolicited.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David (david@unsolicited.net):
> Casey Schaufler wrote:
>> Do you have a libcap that reflects the change from 32 capabilities
>> to 64? You'll be looking for libcap.so.2.06 or thereabouts.
>>   
> Adding libcap-2.08 and recompiling ntpd has fixed the issue, and I'm now 
> running normally, thanks!

I don't understand why, though.  Looking at the ntpd code (ntp-4.2.4p4)
it just does a cap_set_proc(cap_from_text("X=epi"));  It should simply
be sending in the _LINUX_CAPABILITY_VERSION which shipped with libcap,
which should have been _V1, and the kernel should honor that so long as
you didn't try to send in caps > 31, which ntpd wasn't.

> Was this userspace visible change planned in advance for 2.6.25 ? ... as I 
> guess a few other people with venerable old userspace components may come 
> across this issue.
>
> Cheers
> David

It's been in the works a long time and we thought we'd done pretty
well with backward compatibility.  I really don't see why you had
that failure!

Do you know which version of libcap you had before?

thanks,
-serge

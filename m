Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbYFWJsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbYFWJsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 05:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYFWJsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 05:48:04 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:12829 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbYFWJsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 05:48:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gRjVd5uHW/6o9gVzX8qg/yIJFhxnQdUQWGVBDWm+kte/ny59805WDY58+Fy4ljhPGu
         L0MJe9k48zJrv1OXUfY72n87xCtdNRwsb0w4X42hS9CVYV2Lm9q7mpD5Fy0ygkovrI8F
         OvaL0zu4ynebuHymlnV9wne2kZkl7Y9AIZxiA=
Message-ID: <cfd18e0f0806230248g3a2ab795s63de2b96538ebdd0@mail.gmail.com>
Date: Mon, 23 Jun 2008 11:48:00 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: nanosleep() uses CLOCK_MONOTONIC, should be CLOCK_REALTIME?
Cc: "Michael Kerrisk" <mtk.manpages@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "john stultz" <johnstul@us.ibm.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Roman Zippel" <zippel@linux-m68k.org>
In-Reply-To: <e2e108260806230134g48f5ac63mb93256e08c57b4f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <485E00CD.9060503@gmail.com>
	 <e2e108260806230134g48f5ac63mb93256e08c57b4f7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart,

On Mon, Jun 23, 2008 at 10:34 AM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> On Sun, Jun 22, 2008 at 9:35 AM, Michael Kerrisk <mtk.manpages@gmail.com> wrote:
>> Thomas,
>>
>> (I gues you are the right target for this?)
>>
>> The POSIX.1 specification of nanosleep() says:
>>
>>       But, except for the case of being interrupted by a signal, the
>>       suspension time shall not be less than the time  specified  by
>>       rqtp, as measured by the system clock CLOCK_REALTIME.
>>
>>
>> However, reading kernel/hrtimer.c:sys_nanosleep(), it appears that
>> CLOCK_MONOTONIC is used.
>>
>>    return hrtimer_nanosleep(&tu, rmtp, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
>>
>> Is there a reason to use CLOCK_MONOTONIC, instead of CLOCK_REALTIME?  Is it
>> intentional?  If yes, then I should document this in the man-pages.  If not,
>> then it should be fixed.
>
> CLOCK_MONOTONIC works fine even if ntpd steps the clock forward or
> backward, CLOCK_REALTIME not. So the man page should be fixed.

Thanks for your reply, but I'm not quite convinced yet.  The things
is: the Solaris man page also says "CLOCK_REALTIME".  (Of course that
man page may just be parroting the standard.)  Could there not be some
reasonable semantics for a nanosleep() that was based on
CLOCK_REALTIME?

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html

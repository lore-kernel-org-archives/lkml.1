Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbYFWL47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbYFWL47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbYFWL4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:56:51 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:63961 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbYFWL4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:56:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=L85Az/h+O5ndXTy6ceUCFLs2MNSGQFaJBmmqAVFvJgKcz19ZHo8c9b+r+cXvmVjioP
         bNyh6FNsJDcqiL8VI/4M2A4pA21gI8GkAzeeXjfj0Rih1YTrrdjIkCMRHwNZEFp/IeUG
         N0yZw7kNfKJBi00TFTAqvd89MmOzlrCPl8vvs=
Message-ID: <e2e108260806230456w1b1faa0ftd2c8a4114dbdd89@mail.gmail.com>
Date: Mon, 23 Jun 2008 13:56:24 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Subject: Re: nanosleep() uses CLOCK_MONOTONIC, should be CLOCK_REALTIME?
Cc: "Michael Kerrisk" <mtk.manpages@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "john stultz" <johnstul@us.ibm.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Roman Zippel" <zippel@linux-m68k.org>
In-Reply-To: <cfd18e0f0806230248g3a2ab795s63de2b96538ebdd0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <485E00CD.9060503@gmail.com>
	 <e2e108260806230134g48f5ac63mb93256e08c57b4f7@mail.gmail.com>
	 <cfd18e0f0806230248g3a2ab795s63de2b96538ebdd0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 11:48 AM, Michael Kerrisk
<mtk.manpages@googlemail.com> wrote:
> On Mon, Jun 23, 2008 at 10:34 AM, Bart Van Assche
> <bart.vanassche@gmail.com> wrote:
>> On Sun, Jun 22, 2008 at 9:35 AM, Michael Kerrisk <mtk.manpages@gmail.com> wrote:
>>> The POSIX.1 specification of nanosleep() says:
>>>
>>>       But, except for the case of being interrupted by a signal, the
>>>       suspension time shall not be less than the time  specified  by
>>>       rqtp, as measured by the system clock CLOCK_REALTIME.
>>>
>>>
>>> However, reading kernel/hrtimer.c:sys_nanosleep(), it appears that
>>> CLOCK_MONOTONIC is used.
>>>
>>>    return hrtimer_nanosleep(&tu, rmtp, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
>>>
>>> Is there a reason to use CLOCK_MONOTONIC, instead of CLOCK_REALTIME?  Is it
>>> intentional?  If yes, then I should document this in the man-pages.  If not,
>>> then it should be fixed.
>>
>> CLOCK_MONOTONIC works fine even if ntpd steps the clock forward or
>> backward, CLOCK_REALTIME not. So the man page should be fixed.
>
> Thanks for your reply, but I'm not quite convinced yet.  The things
> is: the Solaris man page also says "CLOCK_REALTIME".  (Of course that
> man page may just be parroting the standard.)  Could there not be some
> reasonable semantics for a nanosleep() that was based on
> CLOCK_REALTIME?

Sorry, but I don't think that a nanosleep() based on CLOCK_REALTIME
would have reasonable semantics. The first line of the description in
nanosleep()'s manpage says:
"nanosleep()  delays  the  execution  of  the program for at least the
time specified in *req". So you really need CLOCK_MONOTONIC and not
CLOCK_REALTIME.

The reason why CLOCK_REALTIME is mentioned is probably because other
POSIX man pages define three types of clocks: real, virtual and
profiiling. See e.g. the getitimer() man page
(http://www.opengroup.org/onlinepubs/009695399/functions/setitimer.html).
And an overview of all clock types defined by POSIX can be found here:
http://www.opengroup.org/onlinepubs/000095399/functions/clock_getres.html.

Bart.

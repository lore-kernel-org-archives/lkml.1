Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbYFYNeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbYFYNeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 09:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757676AbYFYNeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 09:34:00 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:50992 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790AbYFYNd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 09:33:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Pu6PURIjGJMUyyNQCx8aoKCBGFxTUDfDi9fdZTwN0D13+WMTI6hn3Eb5XSfNFz6Aux
         ng44fRQum9QY2IkSWgIq7WGngtaJiz7eYUleK1UM0+4CDOBJ8YDRQ9U8S7GkhhLTt/ZV
         MGuzu/3Qu+NlKRMwqB/NjSxfkWNnc8wewPUQE=
Message-ID: <cfd18e0f0806250633j2901aa89u5609f1b9a4a37dc6@mail.gmail.com>
Date: Wed, 25 Jun 2008 15:33:55 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: When did High-Resolution Timers hit mainline?
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "john stultz" <johnstul@us.ibm.com>
In-Reply-To: <e2e108260806242332i2138f7f7t63626d45a33fdce2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0806232335p3e05d690o5a5cef8c9626fae7@mail.gmail.com>
	 <cfd18e0f0806242108s79ccc948n73e2ad5f694ecdaf@mail.gmail.com>
	 <e2e108260806242332i2138f7f7t63626d45a33fdce2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

Just following up a little further here.

On Wed, Jun 25, 2008 at 8:32 AM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> On Wed, Jun 25, 2008 at 6:08 AM, Michael Kerrisk
> <mtk.manpages@googlemail.com> wrote:
>>   The Software Clock, HZ, and Jiffies
>>       The accuracy of various system calls that set timeouts,  (e.g.,
>>       select(2),   sigtimedwait(2))   and  measure  CPU  time  (e.g.,
>>       getrusage(2)) is limited by  the  resolution  of  the  software
>>       clock,  a clock maintained by the kernel which measures time in
>>       jiffies.  The size of a jiffy is determined by the value of the
>>       kernel constant HZ.
>
> Maybe "size of a jiffy" should be replaced by "duration of a jiffy" ?
>
> An explanation of the impact of CONFIG_NO_HZ is missing.
>
> You also missed the fact that since the 2.6 kernel there are two
> constants related to time resolution, namely HZ and USER_HZ. HZ is the
> frequency of the timer interrupt, and 1/USER_HZ is the time resolution
> for system calls that use jiffies as time unit (e.g. the five values
> returned by the times() system call).

As far as I can tell, times() is the only system call that employs
USER_HZ.  Let me know if you think I'm wrong.  The only othe place
where USER_HZ seems to come into play is the time fields displayed in
/proc/PID/stat and /poc/stat.  (My point of verification here is
looking at usages of cputime_to_clock_t() and cputime64_to_clock_t()
in the kernel source.)

> The time resolution of e.g. the
> select() and poll() system calls is 1.0/HZ since the timeout for these
> system calls is specified as a struct timeval or struct timespec.

Yes.  So I think what I'll do is just add some text noting that the
times() syscall is a special case.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html

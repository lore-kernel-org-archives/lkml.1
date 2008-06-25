Return-Path: <linux-kernel-owner+w=401wt.eu-S1752479AbYFYGdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbYFYGdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 02:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYFYGcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 02:32:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:16462 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbYFYGcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 02:32:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OihIJ5yH4ZcG/8dwIQXBbMNRdU0HpTeQUVCVuc2Rt824kvCOOjzyNJVWVwCdK8L2w/
         PzOG2fGnmogdEbshi+q6wcdRVgSgXmqu1WMafGxbg4Xp2Ghuymp3+d4brxPtrC3QuJ8o
         +z1ePnoxZNQHToFna6KqGY08jjqm121d0s6Q4=
Message-ID: <e2e108260806242332i2138f7f7t63626d45a33fdce2@mail.gmail.com>
Date: Wed, 25 Jun 2008 08:32:50 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Subject: Re: When did High-Resolution Timers hit mainline?
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "john stultz" <johnstul@us.ibm.com>
In-Reply-To: <cfd18e0f0806242108s79ccc948n73e2ad5f694ecdaf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0806232335p3e05d690o5a5cef8c9626fae7@mail.gmail.com>
	 <cfd18e0f0806242108s79ccc948n73e2ad5f694ecdaf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 6:08 AM, Michael Kerrisk
<mtk.manpages@googlemail.com> wrote:
>   The Software Clock, HZ, and Jiffies
>       The accuracy of various system calls that set timeouts,  (e.g.,
>       select(2),   sigtimedwait(2))   and  measure  CPU  time  (e.g.,
>       getrusage(2)) is limited by  the  resolution  of  the  software
>       clock,  a clock maintained by the kernel which measures time in
>       jiffies.  The size of a jiffy is determined by the value of the
>       kernel constant HZ.

Maybe "size of a jiffy" should be replaced by "duration of a jiffy" ?

An explanation of the impact of CONFIG_NO_HZ is missing.

You also missed the fact that since the 2.6 kernel there are two
constants related to time resolution, namely HZ and USER_HZ. HZ is the
frequency of the timer interrupt, and 1/USER_HZ is the time resolution
for system calls that use jiffies as time unit (e.g. the five values
returned by the times() system call). The time resolution of e.g. the
select() and poll() system calls is 1.0/HZ since the timeout for these
system calls is specified as a struct timeval or struct timespec.

Bart.

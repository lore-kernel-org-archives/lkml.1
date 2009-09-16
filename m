Return-Path: <linux-kernel-owner+w=401wt.eu-S1759943AbZIPUT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943AbZIPUT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbZIPUTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:19:53 -0400
Received: from mail-pz0-f190.google.com ([209.85.222.190]:39035 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbZIPUTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:19:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UGnDfFEYNJ63WqR+/kgV4s8mFKI5MBUrUcXCXWIaQptm8xfAffzJK3LJ3TmWPe6Cbi
         v9WiN0aUapDAzAcYvvHxWieWv4xv00q7cKu+S5RLVuvSEOSnbK84CqIGth9bVfc3z3PS
         m/k79cvvwCcDJhWpaK5Xr3RyG2ebomvQbqZ/o=
MIME-Version: 1.0
In-Reply-To: <1f1b08da0909161256m376b1292ia4b2f3b2b4e82c34@mail.gmail.com>
References: <alpine.DEB.2.00.0907272218480.30108@gandalf.stny.rr.com>
	 <4A89213C.5090109@cn.fujitsu.com>
	 <20090818215620.A63C.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.0908181454090.727@gandalf.stny.rr.com>
	 <4A939CDF.2000407@cn.fujitsu.com> <4A939D4A.1020706@cn.fujitsu.com>
	 <1f1b08da0909161256m376b1292ia4b2f3b2b4e82c34@mail.gmail.com>
Date: Wed, 16 Sep 2009 12:58:42 -0700
X-Google-Sender-Auth: 9882cf3cc110754a
Message-ID: <1f1b08da0909161258g3e57a579iac2238c2f0916b07@mail.gmail.com>
Subject: Re: [PATCH 2/3] ftrace: add tracepoint for xtime
From: john stultz <johnstul@us.ibm.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 12:56 PM, john stultz <johnstul@us.ibm.com> wrote:
> On Tue, Aug 25, 2009 at 1:14 AM, Zhaolei <zhaolei@cn.fujitsu.com> wrote:
>> From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>>  /* Structure holding internal timekeeping values. */
>>  struct timekeeper {
>>        /* Current clocksource used for timekeeping. */
>> @@ -338,6 +341,8 @@ int do_settimeofday(struct timespec *tv)
>>
>>        update_vsyscall(&xtime, timekeeper.clock);
>>
>> +       trace_gtod_update_xtime(&xtime, &wall_to_monotonic);
>> +
>
> So the only thing to watch out on here is that xtime doesn't hold the
> current time, but the accumulated time. There is some unaccumulated
> time still kept in the clocksource structure.
>
> You probably want (assuming you only need tick granularity time) to
> use current_kernel_time().
>
> As an aside, is there a reason you have to have update callbacks and
> duplicate the time storage instead of using the existing interfaces?
> (ie: Is this due to locking or something else?)

Doh. Sorry, you're actually tracing the timekeeping code. Not using
this to assist tracing. Got this confused.

So yea, I think this should be ok, plus or minus determining if you
really want xtime or xtime_cache.

-john

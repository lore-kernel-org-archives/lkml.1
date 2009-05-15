Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbZEOHAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbZEOHAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 03:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbZEOHAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 03:00:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:6660 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbZEOHAB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 03:00:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CVZ/ycnaN1XC9OXW8YI3NxOKCw5yH9PeoKNK6BCu9ebI1Xcbs0IhOCKV2nua7Cf1Kp
         Ka10vD+pkyxJbK0Y1uWr6GDJPx9bSuXXBVmhvVEWO1n3XkRzjdo8e2VrNGjNEKpbHSsb
         iYqPtzNlsuir/BbuLRiLOgB++AiXZyW1GTtYw=
MIME-Version: 1.0
In-Reply-To: <20090512.203014.71110404.ryov@valinux.co.jp>
References: <2891419e0905040423y27f25ce7y61e5211aded85f99@mail.gmail.com>
	 <20090505.073655.193711315.ryov@valinux.co.jp>
	 <2891419e0905051735s7371e590gc942e4c6c475aa67@mail.gmail.com>
	 <20090512.203014.71110404.ryov@valinux.co.jp>
Date: Fri, 15 May 2009 16:00:00 +0900
Message-ID: <2891419e0905150000x5f19908eh975c83690f38b9ac@mail.gmail.com>
Subject: Re: [PATCH] range-bw: Another I/O scheduling policy of dm-ioband 
	supporting the predicable I/O bandwidth (range bandwidth)
From: Dong-Jae Kang <baramsori72@gmail.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: righi.andrea@gmail.com, menage@google.com, balbir@linux.vnet.ibm.com,
       guijianfeng@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
       agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       chlunde@ping.uio.no, dave@linux.vnet.ibm.com, dpshah@google.com,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp, taka@valinux.co.jp,
       lizf@cn.fujitsu.com, matt@bluehost.com, dradford@bluehost.com,
       ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
       s-uchida@ap.jp.nec.com, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, nauman@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, corsetproject@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ryo.

Sorry for late reply.

2009/5/12 Ryo Tsuruta <ryov@valinux.co.jp>:
> Hi Dong-Jae,
>> >> after bug-fix,I evaluated range-bw according to your configuration and
>> >> test environment
>> >> the result is in new relesed range-bw mail, [PATCH 0/2]
>> >> and more detailed documentation is also available and it can be
>> >> referred in [PATCH 1/2]
>> >>
>> >> Ryo,
>> >> can you check the result ?
>
> I did the same test as before and got the results as expected.
>
>               cgroup1    cgroup2
>  min:max-bw    0:100      0:200
>  -------------------------------------
>  read          100         197
>  write         103         198 [KB/s]
>

I think upper result is reasonable.
because you configured min and  max bandwidth as 0K:100K(for cgroup1)
and 0K:200K(for cgroup2).
So, range-bw supported appropriate and expected bandwidth with 1~3% error range.
minimum bandwidth was satisfied (0K, 0K ) and maximum bandwidth was
limited (100K, 200K)
but there is some considered point in use of range-bw as I described
in [PATCH 0/2] as below.

* Attention
-----------------
Range-BW supports the predicable I/O bandwidth, but it should be
configured in the scope of total I/O bandwidth of the I/O system to
guarantee the minimum I/O requirement. For example, if total I/O
bandwidth is 40Mbytes/sec, the summary of I/O bandwidth configured in
each process group should be equal or smaller than 40Mbytes/sec.
So, we need to check total I/O bandwidth before set it up.

If you need more another information about range-bw, reply to me.

> I got errors while applying your patch, some lines are wrapped with
> carriage returns.
>
>    +extern int policy_range_bw_init(struct ioband_device *dp, int argc,
>  >> char **argv);

Thank you for bug reporting
I will check it again.

>
> Thanks,
> Ryo Tsuruta
>



-- 
Best Regards,
Dong-Jae Kang

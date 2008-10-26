Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbYJZNiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbYJZNiB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 09:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbYJZNhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 09:37:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:51547 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYJZNhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 09:37:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=UoWKfLPHZZ014hW98M738oryIkE5PFrNcQ1X12vbA4CQICLO1AmKLZAH4ZwRGJYMOl
         +JnKIKcvUF1Y2nB4L0LxUdqIBg6gbEY4n1OdnGOY+8a2lhUDWKzPLgLOTVaF5v+VmuR9
         ZNWmaybbxxM9Fg7gBYBrrNdUrtckozonDNVr8=
Message-ID: <2f11576a0810260637q21eaec62q4e2662742541e771@mail.gmail.com>
Date: Sun, 26 Oct 2008 22:37:50 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [RFC][PATCH] lru_add_drain_all() don't use schedule_on_each_cpu()
Cc: "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Nick Piggin" <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       "Hugh Dickins" <hugh@veritas.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>,
       "Lee Schermerhorn" <lee.schermerhorn@hp.com>, linux-mm@kvack.org,
       "Christoph Lameter" <cl@linux-foundation.org>,
       "Gautham Shenoy" <ego@in.ibm.com>, "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <1225019176.32713.5.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2f11576a0810210851g6e0d86benef5d801871886dd7@mail.gmail.com>
	 <2f11576a0810211018g5166c1byc182f1194cfdd45d@mail.gmail.com>
	 <20081023235425.9C40.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <1225019176.32713.5.camel@twins>
X-Google-Sender-Auth: eff5a3f8cbcdde55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

>> @@ -611,4 +613,8 @@ void __init swap_setup(void)
>>  #ifdef CONFIG_HOTPLUG_CPU
>>       hotcpu_notifier(cpu_swap_callback, 0);
>>  #endif
>> +
>> +     vm_wq = create_workqueue("vm_work");
>> +     BUG_ON(!vm_wq);
>> +
>>  }
>
> While I really hate adding yet another per-cpu thread for this, I don't
> see another way out atm.

Can I ask the reason of your hate?
if I don't know it, making improvement patch is very difficult to me.


> Oleg, Rusty, ego, you lot were discussing a similar extra per-cpu
> workqueue, can we merge these two?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbXIBIwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbXIBIwq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 04:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbXIBIwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 04:52:37 -0400
Received: from smtpout.mac.com ([17.250.248.178]:62465 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbXIBIwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 04:52:36 -0400
In-Reply-To: <46D5794D.7030507@redhat.com>
References: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com> <46C4BC46.7000305@redhat.com> <25ae38200708200724sbce2749m7eb27565d7c84e5e@mail.gmail.com> <46C9A867.6090509@redhat.com> <25ae38200708212317h7776768v33a82f646ac6b749@mail.gmail.com> <m3d4xeii2z.fsf@maximus.localdomain> <46CDD98F.2020208@redhat.com> <25ae38200708290248w2cdd152fpbdaa1b123de0b7ef@mail.gmail.com> <33633.simon.1188386980@5ec7c279.invalid> <25ae38200708290454r5be02a2ct568260cb429e4f1a@mail.gmail.com> <46D5794D.7030507@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <2BC3E288-D370-4738-B90A-A47F30CB6536@mac.com>
Cc: Anand Jahagirdar <anandjigar@gmail.com>, Simon Arlott <simon@fire.lp0.eu>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Fork Bombing Patch
Date: Sun, 2 Sep 2007 04:52:21 -0400
To: Chris Snook <csnook@redhat.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 29, 2007, at 09:49:01, Chris Snook wrote:
>> Like this there are many cases..(actually these cases has already  
>> been discussed On LKML 2 months before in my thread named "fork  
>> bombing
>> attack").  in all these cases this printk helps adminstrator a lot.
>
> What exactly does this patch help the administrator do?  If a box  
> is thrashing, you still have sysrq.  You can also use cpusets and  
> taskset to put your root login session on a dedicated processor,  
> which is getting to be pretty cheap on modern many-core, many- 
> thread systems.  Group scheduling is in the oven, which will allow  
> you to prioritize classes of users in a more general manner, even  
> on UP systems.

I've also set up systems where there is a carefully rate-limited  
SCHED_RR 98 ssh process (NIC interrupt thread is SCHED_RR 99) behind  
an additional set of rate-limiting rules in IPtables.  Basically, no  
matter what somebody is doing to the workstation, even if I let them  
create as many processes as they want or get the box completely into  
a swap storm, I can "ssh -p 222 root@some.box".  Once it connects I  
type in two passwords through a custom PAM plugin and then have my  
login script touch /etc/nologin and send SIGSTOP to every

The resource consumption issue is immediately over and I can go about  
kicking the user and filling out all the icky paperwork.

Cheers,
Kyle Moffett




Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbZJFCBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbZJFCBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 22:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbZJFCBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 22:01:30 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:44527 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbZJFCBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 22:01:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PF9ylqUe40tcedqaBOBq4NRMrnvfSSlORPElPcFaUjHB6k1Wru5mMhLUnvM4Srg5aV
         BTDIrc+gvoIQeVmK9l6IkocIxuIY/LCZdCOD8y9SBqXZoepcU3QEzrOuCOC3QiJJZXkU
         hD2MU4wLZgv827czZTB97FHCN5/TT12T/5ij8=
Message-ID: <4ACAA4E4.1090802@gmail.com>
Date: Mon, 05 Oct 2009 19:01:08 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: system gets stuck in a lock during boot
References: <4A922F82.9080000@cn.fujitsu.com> <4A9251EB.8040805@gmail.com>	 <dd18b0c30908241219mdb76311t9334929f34f2c4c3@mail.gmail.com>	 <20090825085919.GB14003@elte.hu> <4A94803A.5060408@gmail.com>	 <20090826073351.GE23435@elte.hu> <4A9549E5.5020002@gmail.com>	 <dd18b0c30909071449q6834e847yb0f27ec971c9564a@mail.gmail.com>	 <20091002211211.GA2633@redhat.com> <20091004174113.GB24418@elte.hu>	 <dd18b0c30910041710y15e1da1k348c0decc05f326f@mail.gmail.com>	 <4ACA96B9.7000909@gmail.com> <1254791938.13160.211.camel@gandalf.stny.rr.com>
In-Reply-To: <1254791938.13160.211.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, 2009-10-05 at 18:00 -0700, Justin P. Mattock wrote:
>    
>> Justin Mattock wrote:
>>      
>
>    
>> o.k. I put back on that system, and
>> hit the error. I add your patch to 2.6.31-rc6,
>> and the latest git(a few days old).
>> I still am hitting this, but with your patch
>> I'm able to see the beginning of this panic:
>> (Ill write it manually)
>>
>> [   2.523966] kernel panic - not syncing: No init found. try passing
>> init= option
>> to the kernel
>> [   2.524394] Pid: 1, comm: swapper Not tainted 2.6.31-rc6 #6
>> [   2.524633] Call Trace:
>> [   2.524875] [<ffffffff813a5b72>] panic+0x75/0x120
>> [   2.525119] [<ffffffff8100910f>] init_post+0xef/0xf5
>>      
>
> Strange. This panic is just telling you it could not find an "init" to
> execute.
>
>    
It is strange, my only guess is something gcc
is doing(like mentioned other systems I have run fine
while using gcc 4.4)
> -- Steve
>
>    
>> [   2.525357] [<ffffffff815f6cf0>] kernel_init+0x198/0x1a3
>> [   2.525600] [<ffffffff8102410a>] child_rip+0xa/0x20
>> [   2.525842] [<ffffffff815f6b58>] ? kernel_init+0x0/0x1a3
>> [   2.526084] [>ffffffff810224100>] ? child_rip+0x0/0x20
>>
>> Seems I only hit this with using gcc 4.5.0 and compiling
>> sysvinit with SELinux support to load the policy at boot.
>> (here's the patch I used
>> http://readlist.com/lists/tycho.nsa.gov/selinux/3/15451.html).
>>
>> Sound's like gcc is doing something(correct me if I'm
>> wrong) because the other systems I have are using the same
>> packages except for and older version of gcc.
>> maybe  I should update sysvinit with a better patch to load the policy.
>>
>> Justin P. Mattock
>>      
>
>
>    
Justin P. Mattock

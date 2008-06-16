Return-Path: <linux-kernel-owner+w=401wt.eu-S1757508AbYFPNxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbYFPNxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbYFPNxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:53:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:62207 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbYFPNxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:53:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=g3LvSVBgFpu0iJjt/7uUBgXCChpmRKphUpit2bJksK9Sa638jf4QY89l+DwZEiEEhr
         nMcLD3ZX5tkfQAZl1/1PIStVmJMegKj3ud496h9KHVX/WXIvtiABO0IfFi3u+ZxNgayo
         lrtfgsOCIRCRdVTPyU1LdlibYwqgBkq2EhyAk=
Message-ID: <19f34abd0806160653w2e92e43o4fb20e198bcb4615@mail.gmail.com>
Date: Mon, 16 Jun 2008 15:53:43 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [Bug #10815] 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Oleg Nesterov" <oleg@tv-sign.ru>, "Adrian Bunk" <bunk@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080616030154.GA7445@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080614144200.GA26421@linux.vnet.ibm.com>
	 <20080614181212.GB26421@linux.vnet.ibm.com>
	 <20080614194338.GA4820@martell.zuzino.mipt.ru>
	 <20080615033001.GE26421@linux.vnet.ibm.com>
	 <20080615162150.GA8289@martell.zuzino.mipt.ru>
	 <20080615181710.GA17915@linux.vnet.ibm.com>
	 <alpine.LFD.1.10.0806151323101.2949@woody.linux-foundation.org>
	 <20080615232754.GD17915@linux.vnet.ibm.com>
	 <alpine.LFD.1.10.0806151633290.2949@woody.linux-foundation.org>
	 <20080616030154.GA7445@martell.zuzino.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 5:01 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Sun, Jun 15, 2008 at 04:38:24PM -0700, Linus Torvalds wrote:
>> On Sun, 15 Jun 2008, Paul E. McKenney wrote:
>> >
>> > If that is the right thing to do.  I would feel better about it if I
>> > could reproduce the failure.
>>
>> Is there some configuration thing that might make it happen for Alexey but
>> not for you? The only obvious one is the normal PREEMPT thing, but
>> PREEMPT_RCU obviously depends on that, so there must be something else.
>>
>> CONFIG_SMP? CONFIG_NO_HZ? CONFIG_[RT|FAIR]_GROUP_SCHED? There's a number
>> of config options that change scheduling details..
>
> The only way I can "fix" rcutorture here is SMP=n (not maxcpus=1!).
>
> Among things tried and do not matter are NO_HZ, HIGH_RES_TIMERS, turning off
> debugging options (one by one and in bulk), DEBUG_PER_CPU_MAPS, HZ tweaks,
> SCHED_MC.
>
> All of this doesn't help, but SMP=n does.

Maybe this is a stupid suggestion, but SLUB _is_ involved here (in
poisoning the object when it is freed). Do you have SLUB_DEBUG_ON=y or
did you check whether it matters if you have these options on or off?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759753AbZJGRrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759753AbZJGRrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759100AbZJGRrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:47:33 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:45915 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978AbZJGRrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:47:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fCmlKYEcHjplpA/jsUVphtTyaD1nisX8GhvvTqqub+eePupmteYqx0KbnT2K1Bsg1b
         vgB12PucMUL0id5Btb+5dqIyBMugZ+mTYVsVDzASf66ycsFx7aKgASHb0hoTNXR5JgWd
         KlgJG7pHmZwus3AXBSqUaO8hyyYuUAEuUSsHA=
Message-ID: <4ACCD422.3080809@gmail.com>
Date: Wed, 07 Oct 2009 10:47:14 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: system gets stuck in a lock during boot
References: <1251096925.7538.121.camel@twins> <4A9251EB.8040805@gmail.com>	 <dd18b0c30908241219mdb76311t9334929f34f2c4c3@mail.gmail.com>	 <20090825085919.GB14003@elte.hu> <4A94803A.5060408@gmail.com>	 <20090826073351.GE23435@elte.hu> <4A9549E5.5020002@gmail.com>	 <dd18b0c30909071449q6834e847yb0f27ec971c9564a@mail.gmail.com>	 <20091002211211.GA2633@redhat.com>	 <1254792249.13160.213.camel@gandalf.stny.rr.com>	 <20091006203225.GC2631@redhat.com>	 <1254880921.1696.112.camel@gandalf.stny.rr.com>	 <4ACC001D.4050105@gmail.com>	 <1254920429.1696.127.camel@gandalf.stny.rr.com>	 <4ACCAB54.4010408@gmail.com>	 <1254928298.1696.166.camel@gandalf.stny.rr.com>	 <4ACCB934.7070805@gmail.com> <1254931582.1696.171.camel@gandalf.stny.rr.com>
In-Reply-To: <1254931582.1696.171.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2009-10-07 at 08:52 -0700, Justin P. Mattock wrote:
>
>    
>>>
>>>        
>> What I think is happening is while building
>> sysvinit with the SELinux patch, sysvinit is looking
>> in /lib for libselinux(but could be wrong) but libselinux is in
>> /lib64.
>> (here's my excuse as a newbie:)
>>    part of a pain when building an x86_64 multilib is building
>> everything to point to lib64(pure64 with the soft link
>> lib64 ->  lib makes life so much easier).
>>
>> I'm going to look at that patch and see how it tells
>> -lselinux -lsepol to find the libs.
>> (if this is the case then I must admit I am a real
>> newbie, and apologize for the confusion).
>>      
>
> Justin,
>
> Just being able to monkey around with the init code on top of SELinux
> already qualifies you to be well beyond a newbie ;-)
>
> -- Steve
>
>
>
>    
Thanks man!!(I really appreciate that).
Im looking at sysvinit right now
Im thinking all it really needs is
LIBDIR/LDFLAGS=-L/lib64 -lselinux -lsepol
in the Makefile or something in that area.

Justin P. Mattock

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759442AbZJGPxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442AbZJGPxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbZJGPxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:53:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:8580 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbZJGPxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:53:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sUzX+0YirmoFUCc3KDAr4mINreL+jwCVRKa5pQq4HzlQoYiq2BcqCFDueX2nPX47n4
         qjJmVtpIMEA0mNOSz1h1LqkKn2+4jv7as+FQSclk8mZWIOFdg7VEQ2ZKl5AN/1LdVuFO
         qxKSdq+HUPkfLUpJe/t/KFUzWYCsZk/o7037A=
Message-ID: <4ACCB934.7070805@gmail.com>
Date: Wed, 07 Oct 2009 08:52:20 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: system gets stuck in a lock during boot
References: <1251096925.7538.121.camel@twins> <4A9251EB.8040805@gmail.com>	 <dd18b0c30908241219mdb76311t9334929f34f2c4c3@mail.gmail.com>	 <20090825085919.GB14003@elte.hu> <4A94803A.5060408@gmail.com>	 <20090826073351.GE23435@elte.hu> <4A9549E5.5020002@gmail.com>	 <dd18b0c30909071449q6834e847yb0f27ec971c9564a@mail.gmail.com>	 <20091002211211.GA2633@redhat.com>	 <1254792249.13160.213.camel@gandalf.stny.rr.com>	 <20091006203225.GC2631@redhat.com>	 <1254880921.1696.112.camel@gandalf.stny.rr.com>	 <4ACC001D.4050105@gmail.com>	 <1254920429.1696.127.camel@gandalf.stny.rr.com>	 <4ACCAB54.4010408@gmail.com> <1254928298.1696.166.camel@gandalf.stny.rr.com>
In-Reply-To: <1254928298.1696.166.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2009-10-07 at 07:53 -0700, Justin P. Mattock wrote:
>    
>> Steven Rostedt wrote:
>>      
>>> On Tue, 2009-10-06 at 19:42 -0700, Justin P. Mattock wrote:
>>>
>>>
>>>        
>>>>>
>>>>>            
>>>> o.k. applied your patch, but unfortunantly
>>>> I still am hitting this kernel panic.
>>>>
>>>> must admit I have no idea why this is doing this.
>>>> (but am willing to sit through this, because eventually
>>>> sooner or later will hit this if I update gcc).
>>>>
>>>>          
>>> But the panic you showed was that it could not find an init to execute.
>>> Which looks like a setup issue and not a kernel bug.
>>>
>>> -- Steve
>>>
>>>
>>>
>>>
>>>        
>> That's whats getting me, i.g. if I compile
>> sysvinit normally without adding an SELinux patch
>> the system boots, as soon as I compile sysvinit with
>> SELinux support to load the policy, bam... I hit this.
>>
>> I can send a post to SELinux and see what they think,
>> and the go from there.
>>      
>
> Oh! It's an SELinux thing. It probably prevents you from executing
> init ;-)
>
> -- Steve
>
>
>
>    
What I think is happening is while building
sysvinit with the SELinux patch, sysvinit is looking
in /lib for libselinux(but could be wrong) but libselinux is in
/lib64.
(here's my excuse as a newbie:)
  part of a pain when building an x86_64 multilib is building
everything to point to lib64(pure64 with the soft link
lib64 -> lib makes life so much easier).

I'm going to look at that patch and see how it tells
-lselinux -lsepol to find the libs.
(if this is the case then I must admit I am a real
newbie, and apologize for the confusion).

Justin P. Mattock



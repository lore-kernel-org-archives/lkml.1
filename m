Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbYI0FB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbYI0FB6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 01:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbYI0FBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 01:01:49 -0400
Received: from smtp110.prem.mail.sp1.yahoo.com ([98.136.44.55]:20984 "HELO
	smtp110.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751130AbYI0FBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 01:01:48 -0400
X-YMail-OSG: IA3Ft0AVM1lnUhm0t7VFinn8I1G7_tvQglFgZvXolIgwSco_KRiekJqI4iXcT73HLL_sGJZK.C1Jcld_sFeGVbmFmxBMV8fbWTT.Ocg9PCkeZSkCHMC5UM3TJoao7yGDHooO7urhN_ExaHEXCN2SKmMWQm.i7.xsM1HRMEWR1iafmEF5hw--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <48DDBE2E.3010006@schaufler-ca.com>
Date: Fri, 26 Sep 2008 22:01:34 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Tilman Baumann <tilman.baumann@collax.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: SMACK netfilter smacklabel socket match
References: <48DBC9A1.20900@collax.com> <48DC5A45.8020801@schaufler-ca.com> <E33DFA86-F040-413F-8156-EDCB879F4CEE@collax.com>
In-Reply-To: <E33DFA86-F040-413F-8156-EDCB879F4CEE@collax.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Baumann wrote:
> Am 26.09.2008 um 05:43 schrieb Casey Schaufler:
>
>> Tilman Baumann wrote:
>>> Hi all,
>>>
>>> i made some SMACK related patches. I hope this list is the right 
>>> place to post them.
>>
>> Here and, probably more importantly 
>> linux-security-module@vger.kernel.org as that's
>> my primary hang out.
>>
>>> The intention behind this patch is that i needed a way to (firewall) 
>>> match for packets originating from specific processes.
>>> The existing owner match did not work well enough, especially since 
>>> the cmd-owner part is removed.
>>> Then i thought about a way to tag processes and somehow match this 
>>> tag in the firewall.
>>> I recalled that SELinux can do this (SECMARK) but SELinux would have 
>>> been way to complex for what i want. But the idea was born, i just 
>>> needed something more simple.
>>>
>>> SMACK seemed to be the right way. So i made a little primitive 
>>> netfilter match to match against the security context of sockets.
>>> SMACK does CIPSO labels, but this was not what i wanted, i wanted to 
>>> label the socket not the packet (on the wire).
>>> This of course only works for packets with a local socket, but this 
>>> was my intention anyway.
>>>
>>> This way i can label a process and all it's sockets carry the same 
>>> label which i then can use to match against in the firewall.
>>>
>>
>> Hmm. It looks as if your code will do what you're asking it to do.
>> Are you going to be happy with the access restrictions that will be
>> imposed by Smack?
>
> I helped myself with rules like this.
> _ foo rwx
> But i wanted to add some security stuff like selinux for years,
> and SMACK seems to be just great.
> So i will spend some time making security rules after i got this routing
> stuff to work. :)
>
I confess that I'm still not completely sure what you're up too,
but you might want to look at smackpolyport (it's in the smack-util
tarball) and might make your life easier if you want to have a
single server (running at foo) that deals with connections from
processes with multiple labels.



Return-Path: <linux-kernel-owner+w=401wt.eu-S1753603AbYJAPVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbYJAPVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 11:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYJAPVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 11:21:40 -0400
Received: from smtp105.prem.mail.sp1.yahoo.com ([98.136.44.60]:32717 "HELO
	smtp105.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752108AbYJAPVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 11:21:39 -0400
X-YMail-OSG: RdsDbtYVM1liBrzsX5vezqKRP3bt_gf2R1LuYzmuv3_rXPgFFmTpM_Sg5BwLOupbgAAmeRbwn196sDIxu8_6YtwjzAFwpev9OH0DqxwFPMTJ6wazUCMdT3G8JOWEfoH5gJYqCc3Lus2GYkUJnm4b7xZYwsjH
X-Yahoo-Newman-Property: ymail-3
Message-ID: <48E3957A.7040201@schaufler-ca.com>
Date: Wed, 01 Oct 2008 08:21:30 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Tilman Baumann <tilman.baumann@collax.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: SMACK netfilter smacklabel socket match
References: <48DBC9A1.20900@collax.com> <48DC5A45.8020801@schaufler-ca.com> <E33DFA86-F040-413F-8156-EDCB879F4CEE@collax.com> <48DDBE2E.3010006@schaufler-ca.com> <48E1007F.4000400@collax.com> <48E19D01.9050809@schaufler-ca.com> <48E35F36.4030203@collax.com>
In-Reply-To: <48E35F36.4030203@collax.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Baumann wrote:
> Casey Schaufler wrote:
>>> Casey Schaufler wrote:
>> If you really want to be abusive you could replace the smack_access()
>> function in security/smack/smack_access.c (of all places) with a no-op
>> returning 0 in all cases.
>
> I thought of that too. :)
> But i would rather like to use the thing in it's intended function 
> sometime in the future.

Even better.


>>> What I then to is write iptables OUTPUT chain matches which match 
>>> for any of these labels and set some connection marks and firewall 
>>> marks.
>>> Which I then can use in routing rules to give different routing 
>>> rules to specific processes. (Like all proxy traffic over a second 
>>> DSL line)
>>>
>>> I know, it's totally crazy. But it seems to work. :)
>>> I just hope the security part of this all will not break anything. 
>>> But it does not look like it would right now.
>>
>> Smack will eventually bite you if you're not careful, but users of
>> MAC systems wouldn't be surprised by that.
> Speaking of the devil...
> This is exactly what happened to me right now. I have problems with 
> _some_ https connects. The problem lies somewhere in openssl.
> I did not yet find any clue with strace.
> Is there some straight forward way to audit/debug LSM interventions?

strace is probably your best bet, as it will tell you what syscalls
fail. Your current situation is most likely a case where your program
running with a label "Foo" is trying to communicate with a service on
a machine that doesn't talk CIPSO and hence Smack is treating all
packets to and from that host with the ambient (%cat /smack/ambient)
label, which is "_" unless you've changed it.

> I have probably missed something that a labeled process could not do 
> as a '_' process could. Have no idea right now, but it is probably 
> something stupidly simple.
>

A labeled system hoping to get services from an unlabeled server is the 
biggest
single pain in dealing with labeled systems. Per-host labeling is in the 
works,
and it will help in some cases. What I really need is a way to designate an
unlabeled host as safe to talk to at any label, but it will take some 
serious
work to come up with a scheme that makes that palatable for a labeled 
environment.
I know that SELinux allows for it, but the purist in me has serious doubts.

>> I don't think it's crazy,
>> I think it's a matter of using what's available in novel ways.
> I like that attitude. :)

It got me where I am today. Hmm, maybe you should be just a little bit 
careful.


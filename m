Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbZKARn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbZKARn4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 12:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbZKARnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 12:43:55 -0500
Received: from smtp101.prem.mail.sp1.yahoo.com ([98.136.44.56]:48272 "HELO
	smtp101.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752966AbZKARny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 12:43:54 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: w8xwOJ4VM1nOuwoqmP7OmPFKVWrHaruIb3H1mYej0U.ncGIKONm_q0AF0sgMGNJFN9q7S.GGpzvwzYSihKltcSgm.kFgqK810ucuTA6Yte5NP2qvpZ6yhFNhsKQKipAWTyOu6DGKK8KEl_avwTUvakeL4XLYN5mBRiBoY7h4imzZXXD.wi0b0p7AjsUrYVJTLmUv7RWC0UVjMlIfEuAOf6T5v1UHPdTpwE22psmMy7WiuXnVyW8O998FGkUalbzes3lyP1FVUlHSV1fec2phpbwzc4RnaJis558m_I3s7xnvXACAa1nkxFOu74gnpS.7fQajciQy7KC9LvjF2nRWa5YKlvIlZWVzISvrrjrBJkj0i_C10AlYv_c7ILOPZ6jjipfCvPfofbAfcg--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AEDC8DD.4080806@schaufler-ca.com>
Date: Sun, 01 Nov 2009 09:43:57 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: David Wagner <daw-news@cs.berkeley.edu>
CC: linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: symlinks with permissions
References: <20091025062953.GC1391@ucw.cz> <4AE91658.9090105@schaufler-ca.com> <20091030140745.GC1481@ucw.cz> <4AEBB86F.3090601@schaufler-ca.com> <hcjk2m$v46$1@taverner.cs.berkeley.edu>
In-Reply-To: <hcjk2m$v46$1@taverner.cs.berkeley.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Wagner wrote:
> Casey Schaufler  wrote:
>   
>> Pavel Machek wrote:
>>     
>>> Look again. I can count on paths if I can prevent mounts and
>>> hardlinks.
>>>       
>> But you can't.
>>     
>
> Yes, he can and did.  See Pavel's original post with his
> attack script.  It's all there!
>
> Hardlinks: in his *original* post, listing the attack script,
> Pavel checks the hardlink count, which does defend against
> hardlinks.  So can we drop the hardlink objection?
>
> Mounts: can only be exploited by root.  On many Linux systems,
> one cannot defend against a threat model where root is malicious,
> and as a consequence, root-only attacks are out of scope for
> those systems.  For those systems, this /proc mechanism is
> a security hole: it enables attacker to do bad stuff they
> couldn't have done without it.
>
>   
>> I refer you back to the long and tedious arguments
>> against pathname based access controls.
>>     
>
> I don't find that reference helpful.  Those arguments don't
> seem relevant to this situation, as far as I can see.  I would
> find specificity more useful than analogies.
>
> Pavel has provided a concrete attack script.  If you believe
> that the protections afforded by that script can be circumvented,
> how about showing us the specific attack, described to a similar
> level of concreteness and specifity, that demonstrates how to
> upgrade the read-only fd to a read-write fd without using /proc?
>
> Put another way: if you are right that the arguments about
> pathname based access controls apply here and lead to the
> conclusions you are espousing, then you should be able to
> exhibit a specific, concrete, fully specified attack on Pavel's
> script, without using /proc.  Right?
>   

No. The going in premise, that the behavior is a security flaw,
is incorrect. The mode bits on the file allow the requested access.
What the mode bits were when the file was opened, and what the mode
bits on the path used to get to the file were at the time of
the open are irrelevant and no amount of sound logic that assumes
otherwise has any value.

I can accept that you don't like the behavior. The behavior is
nonetheless consistent with the access controls of the file system.
If you change the current behavior you will introduce an arbitrary
special case to the file system object access control model. It is
unfortunate that the people who invented the fd file system (now
implemented as part of /proc) did not take the consequences of
adding an additional object naming mechanism for files into
account, but they were hardly the first to skip that step and I
dare say that they weren't the last.

So "fix" the "problem". You'll just be replacing one questionable
behavior with another, and you'll be making the security model
one paragraph harder to describe.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   


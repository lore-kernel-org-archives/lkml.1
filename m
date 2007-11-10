Return-Path: <linux-kernel-owner+w=401wt.eu-S1756408AbXKJXOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbXKJXOV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 18:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbXKJXNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 18:13:52 -0500
Received: from mail8.dotsterhost.com ([66.11.233.1]:50984 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755576AbXKJXNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 18:13:50 -0500
Message-ID: <47363B44.4040100@crispincowan.com>
Date: Sat, 10 Nov 2007 15:14:12 -0800
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "Dr. David Alan Gilbert" <linux@treblig.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
References: <473380AD.5070801@crispincowan.com>	<20071110220455.GB24195@gallifrey>	<47362C7C.2050202@crispincowan.com>	<20071110222414.GC24195@gallifrey>	<47363381.4030103@crispincowan.com> <20071110225755.5dd9b52b@the-village.bc.nu>
In-Reply-To: <20071110225755.5dd9b52b@the-village.bc.nu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Can you explain why you want a non-privileged user to be able to edit
>> policy? I would like to better understand the problem here.
>>     
> Because root doesn't trust users who in turn may not trust apps they run
> or wish to control things. I don't see a problem with that viewpoint in
> terms of forbidding things providing the user (or process tree) does not
> get to undo rules merely add more restrictions.
>   
Do you mean that the OS privilege of "uid 0" does not trust
non-privileged users? Or you mean that the human in charge of root on
the box does not trust the human who owns the account "alice" on the box?

In the case of the former, this is exactly why AppArmor does not let
non-privileged users edit security policy. SELinux, SMACK, LIDS, etc.
also all treat manipulating policy as privileged.

In the case of the latter, my main claim is that such circumstances are
rare, because most users have their own personal workstation. Of course
there are exceptions where people are using a multi-user host, and I'm
not saying that there is anything wrong with that, just that AppArmor is
not particularly good at supporting that environment.

I know that multi-user machines is the classic UNIX environment, but
that model has slowly faded away and is little used any more, so
AppArmor made a trade-off for simplicity at the expense of supporting
this use case.

User-extensible security policy is a hard problem, and AppArmor does not
attempt to solve it.

>> non-privileged user to further tighten the profile on a program. To me,
>> that adds complexity with not much value, but if lots of users want it,
>> then I'm wrong :)
>>     
> Assuming you have any value in the first place, which is another topic, I
> can see value for this in all the security models.
>   
There is value in most features, and the question is whether the feature
pays its freight, does the value exceed the cost? AppArmor is
particularly sensitive to cost/benefit ratios, because much of
AppArmor's value is its simplicity, so there is a naturally high barrier
to adding complicating features to AppArmor.

All of this is valid discussion for how AppArmor might be improved, but
is far, far removed from the dual question that Arjan posed:

    * Is the model valid? Not "is it exactly what I want?" but merely
      "is it non-silly, such that clearly it provides value to some users?"
    * Does the code live up to the model?

I submit that the AppArmor model is valid, even if it totally failed all
of David Gilbert's questions (I think AppArmor can actually provide
about half of what he asked for).

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work


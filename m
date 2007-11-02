Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbXKBIP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbXKBIP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 04:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbXKBIPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 04:15:14 -0400
Received: from sacred.ru ([62.205.161.221]:43730 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbXKBIPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 04:15:12 -0400
Message-ID: <472ADC78.6070706@openvz.org>
Date: Fri, 02 Nov 2007 11:14:48 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
CC: Pavel Emelyanov <xemul@openvz.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] PID namespace design bug, workaround
References: <20071101144307.GA29566@elte.hu>	<4729E7E4.8070208@openvz.org>	<4729E936.4040400@redhat.com>	<4729EB3C.9050102@openvz.org>	<472A6D91.1020300@redhat.com>	<472AD7D6.80900@openvz.org> <20071102010419.23f3db5c.akpm@linux-foundation.org>
In-Reply-To: <20071102010419.23f3db5c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 02 Nov 2007 11:14:48 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 02 Nov 2007 10:55:02 +0300 Pavel Emelyanov <xemul@openvz.org> wrote:
> 
>> Ulrich Drepper wrote:
>>> -----BEGIN PGP SIGNED MESSAGE-----
>>> Hash: SHA1
>>>
>>> Pavel Emelyanov wrote:
>>>> The "fix" I mention is just returning -EINVAL in case user orders 
>>>> CLONE_NEWPIDS
>>> That is the "fix" you were referring to?  I was hoping you have a sketch
>>> for a real solution.  If nobody can think of a way to fix this PID
>> Looks like we misunderstood each other. Can you please elaborate on 
>> what exactly is broken in pid namespaces?
> 
> Isn't it this?
> 
> http://lkml.org/lkml/2007/11/1/141

That was the initial problem, and I already answered to Ingo about
it - pid, obtained in one pid namespace shouldn't be used in another.
This is not a design bug, but a design idea. If he managed to get two
threads in different namespaces, then we should fix this ability (but 
I thought that I handled it - the copy_pid_ns call doesn't allow to 
create a new thread in a new namespace:

        new_ns = ERR_PTR(-EINVAL);
        if (flags & CLONE_THREAD)
                goto out_put;

) I should have first asked Ingo about how he managed to get two 
threads in different namespaces to fix this, but Ulrich said that 

 "everything else I have seen simply doesn't work without
  breaking something"

so I asked him to elaborate on this - what _else_ doesn't work.

Thanks,
Pavel

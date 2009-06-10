Return-Path: <linux-kernel-owner+w=401wt.eu-S1760948AbZFJUrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948AbZFJUrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 16:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbZFJUrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 16:47:08 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:49430 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbZFJUrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 16:47:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LD9AFX28DG4xUwuFaYsMR1ef2NIcdO9Mj3+P3AM+WVMQxJGT+kY+OBMGa5Dh7w0XiR
         pdeWxDjzWs9A/qFIqF4UOKkYR6UEIn5tNfepnQ7AXvqX1SzSh2QZM/XJQyZC/BEXssiY
         SCJlqmtZK7ey9KO85SPmckhnTFiJChrzFWjeU=
MIME-Version: 1.0
In-Reply-To: <20090610204318.GA8147@elte.hu>
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI>
	 <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain>
	 <4A3017D1.5010708@cs.helsinki.fi> <20090610204318.GA8147@elte.hu>
Date: Wed, 10 Jun 2009 23:47:07 +0300
X-Google-Sender-Auth: 8ab0ec8924c61039
Message-ID: <84144f020906101347y3e250f4bme2d1c60dd5993ffc@mail.gmail.com>
Subject: Re: [GIT PULL] Early boot SLAB for 2.6.31
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, hannes@cmpxchg.org, mpm@selenic.com,
       npiggin@suse.de, yinghai@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 11:43 PM, Ingo Molnar<mingo@elte.hu> wrote:
>
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>
>> Linus Torvalds wrote:
>>>
>>> On Wed, 10 Jun 2009, Pekka J Enberg wrote:
>>
>>>> I already have patches for that but they are against the -tip
>>>> tree so I think we ought to just merge this series to mainline
>>>> and fix everything up in subsystem trees for 2.6.31 proper.
>>>
>>> Hmm. Are there any reasons why the scheduler fixups can't go in
>>> this series? Do they depend on other things in -tip?
>>
>> The patches are rebased to -tip, yeah. I can do a version against
>> your tree if you want but that will mean merge conflicts for Ingo.
>> Hmm?
>
> I'm a tiny bit nervous about the tested-ness of the patches. Such
> stuff rarely works at first try. But it's obviously nice changes.

Yeah, I was thinking of sitting on them until 2.6.32 and put them into
linux-next after the merge window closes. But Linus seems to want them
and with the fallback in place, we can probably fix any fall out quite
easily.

> What kind of conflicts are there against -tip? The diffstat suggests
> it's mostly in-SLAB code, right? There shouldnt be much to conflict,
> except kmemcheck - which has more or less trivial callbacks there.

The conflicting bits are the patches that remove bootmem allocator
uses in arch/x86 and kernel/sched.c.

                        Pekka

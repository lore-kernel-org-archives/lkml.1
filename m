Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbYBYFVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbYBYFVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 00:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbYBYFUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 00:20:35 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:41890 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbYBYFUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 00:20:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=aYwajFJgPpDV74iOMVstOcae+8TU3U7Xxk/8IqlXSY9l4FwnIra1X6p7Xj+imyiTKB87r1G0dQE6AwbpNsS+moJVwziRaLKwjknhP2eu5/qIrW0ny2/lQ2/lBO60kt1x7y+tfoNEXslwsNouB4WF80cUf0QKPLAldgtK/zZkP20=
Message-ID: <47C2500E.9080407@gmail.com>
Date: Mon, 25 Feb 2008 00:20:14 -0500
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
Reply-To: gregory.haskins@gmail.com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: "Bill Huey (hui)" <bill.huey@gmail.com>
CC: gregory.haskins@gmail.com, Pavel Machek <pavel@ucw.cz>,
       Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       kevin@hilman.org, cminyard@mvista.com, dsingleton@mvista.com,
       dwalker@mvista.com, npiggin@suse.de, dsaxena@plexity.net, ak@suse.de,
       gregkh@suse.de, sdietrich@novell.com, pmorreale@novell.com,
       mkohari@novell.com
Subject: Re: [PATCH [RT] 11/14] optimize the !printk fastpath through the
 lock acquisition
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>	 <20080221152722.4804.77478.stgit@novell1.haskins.net>	 <20080222191837.GE6060@ucw.cz> <47BF4AC5.7070507@gmail.com> <9810cff90802221643g7d993af4k33f29fb4a4663407@mail.gmail.com>
In-Reply-To: <9810cff90802221643g7d993af4k33f29fb4a4663407@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Huey (hui) wrote:
> 
> The might_sleep is annotation and well as a conditional preemption
> point for the regular kernel. You might want to do a schedule check
> there, but it's the wrong function if memory serves me correctly. It's
> reserved for things that actually are design to sleep.

Note that might_sleep() already does a cond_resched() on the 
configurations that need it, so I am not sure what you are getting at 
here.  Is that not enough?


> The rt_spin*()
> function are really a method of preserving BKL semantics across real
> schedule() calls. You'd have to use something else instead for that
> purpose like cond_reschedule() instead.

I dont quite understand this part either.  From my perspective, 
rt_spin*() functions are locking constructs that might sleep (or might 
spin with the new patches), and they happen to be BKL and wakeup 
transparent.  To me, either the might_sleep() is correct for all paths 
that don't fit the in_atomic-printk exception, or none of them are.

Are you saying that the modified logic that I introduced is broken?  Or 
that the original use of the might_sleep() annotation inside this 
function is broken?

-Greg

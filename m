Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbYHUPXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbYHUPXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbYHUPXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:23:40 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:39662 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbYHUPXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:23:39 -0400
Message-ID: <2270.69.2.248.210.1219330681.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <20080821145333.GF6690@linux.vnet.ibm.com>
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com>
    <1219313231.8651.101.camel@twins> <48AD4A0B.8020805@s5r6.in-berlin.de>
    <1219316568.8651.107.camel@twins>
    <20080821114745.GD21089@linux.vnet.ibm.com>
    <1219320206.8651.116.camel@twins>
    <20080821145333.GF6690@linux.vnet.ibm.com>
Date: Thu, 21 Aug 2008 08:58:01 -0600 (MDT)
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger 2.6.27-rc4 
     released
From: jmerkey@wolfmountaingroup.com
To: paulmck@linux.vnet.ibm.com
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "David Howells" <dhowells@redhat.com>
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>> Still, I'd like Jeff to show his C, the resulting asm and the intent for
>> the volatile and barrier versions of his code (well, little snippets of
>> his code obviuosly).
>>
>> Either he doesn't understand barriers (nothing to be ashamed about), or
>> we might have more trouble lurking in the rest of the kernel.
>
> Sounds fair to me!
>
> 							Thanx, Paul
>

I have thoroughly reviewed Linux memory barriers and the efficacy of the
barriers as defined in Linux are not the issue here.  the code segment
discussed sits and spins on a variable waiting for a specific state, and
its a spinlock which creates a hard barrier, so no amount of barrier usage
should nor does matter here.  Even if a processor was late in flushing its
writes, sooner or later the spinning processor would see the change in the
shared memory address -- IF IT WERE ACTUALLY A SHARED REFERENCE.  What I
am seeing is not an issue of races between processors on load/store
operations, but cases where gcc has chosen to optimize away global
references entirely.

Jeff


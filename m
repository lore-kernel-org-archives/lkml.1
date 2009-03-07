Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbZCGAKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbZCGAKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 19:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbZCGAK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 19:10:28 -0500
Received: from gw.goop.org ([64.81.55.164]:55296 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbZCGAK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 19:10:28 -0500
Message-ID: <49B1BB6F.2080800@goop.org>
Date: Fri, 06 Mar 2009 16:10:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, mingo@elte.hu,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: introduce bootmem_state
References: <> <1236257708-27269-7-git-send-email-penberg@cs.helsinki.fi> <49B02498.9080300@kernel.org> <49B02C68.1030203@cs.helsinki.fi> <49B0640A.5080607@kernel.org> <49B0BF46.4080405@zytor.com> <49B19FB4.40909@goop.org> <49B1B2E9.5050507@zytor.com>
In-Reply-To: <49B1B2E9.5050507@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>>
>> Please, no.  system_state should be deprecated; its hard enough to 
>> have a notion of some kind of system-wide state, but putting 
>> subsystem specific substates into it just makes things worse.
>>
>
> Does it?  It seems to me to have a bunch of state variables which can 
> interact in $DEITY knows how many ways sounds like a bad idea.

If each state variable describes the state of a single subsystem in a 
well-defined way then it is meaningful and fairly easy to understand;  I 
would love to have a straightforward way to query which allocator is 
safe to use at a given moment.

The total number of states is always going to be subsys1 * subsys2 * 
..., but folding them all into one state variable only makes sense if we 
have a well-defined set of states *and* transitions between them.  But 
even then it implies that we have enough coupling between our subsystems 
that we would even care what their aggregate state is, which is already 
a bad idea.  If we keep the internal workings of our subsystems as 
internal details, then having private state variables is the way to go.

The real problem with system_state is that it has a few broadly-defined 
values, but no real explanation of what they mean, so they end up 
getting used in inappropriate ways (like the virt_addr_valid() thing I 
fixed yesterday).

    J


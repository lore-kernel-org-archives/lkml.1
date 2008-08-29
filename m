Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbYH2Q6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbYH2Q6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754922AbYH2Q6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:58:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43270 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbYH2Q6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:58:08 -0400
Date: Fri, 29 Aug 2008 12:58:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <gregory.haskins@gmail.com>
cc: Andi Kleen <andi@firstfloor.org>, Gregory Haskins <ghaskins@novell.com>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] seqlock: serialize against writers
In-Reply-To: <48B8254D.1010206@gmail.com>
Message-ID: <alpine.DEB.1.10.0808291256310.17917@gandalf.stny.rr.com>
References: <20080829154237.1196.66825.stgit@dev.haskins.net> <87abevpzv7.fsf@basil.nowhere.org> <48B81F60.3080409@gmail.com> <20080829162216.GW26610@one.firstfloor.org> <48B82349.1020109@gmail.com> <alpine.DEB.1.10.0808291233280.17917@gandalf.stny.rr.com>
 <48B8254D.1010206@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 29 Aug 2008, Gregory Haskins wrote:
> 
> Yeah, ideas crossed in the mail ;)
> 
> I could just force all of the seqbegins to hit the slowpath by hacking
> the code and see what happens (aside from slowing down, of course ;)
> 
> Question: Which seqlock_t does userspace use?  I assume it uses
> seqlock_t and not raw_seqlock_t.  But the only reason that I ask is that
> I converted raw_seqlock_t to use the new style as well to be consistent,
> even though it is not strictly necessary for the same reasons.  So if
> perchance userspace uses the raw variant, I could solve this issue by
> only re-working the seqlock_t variant.  Kind of a long shot, but figured
> I would mention it :)

I answered this on IRC, but this is for the rest of those reading this 
thread.

Userspace (vsyscalls) can only use raw_seqlock_t. And only the read 
version for that matter. Since the read of raw_seqlock_t is just that, a 
read, no writes, and no jumping to other functions on contention.

The vsyscalls should never use the -rt seqlock_t. Not modifying the raws 
here should make us golden.

-- Steve


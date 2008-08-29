Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbYH2QfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbYH2QfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbYH2QfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:35:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41177 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbYH2QfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:35:08 -0400
Date: Fri, 29 Aug 2008 18:37:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>, mingo@elte.hu,
       rostedt@goodmis.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] seqlock: serialize against writers
Message-ID: <20080829163749.GX26610@one.firstfloor.org>
References: <20080829154237.1196.66825.stgit@dev.haskins.net> <87abevpzv7.fsf@basil.nowhere.org> <48B81F60.3080409@gmail.com> <20080829162216.GW26610@one.firstfloor.org> <48B823F6.1010509@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B823F6.1010509@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 12:29:42PM -0400, Gregory Haskins wrote:
> Andi Kleen wrote:
> >> Im running it on a x86_64 box as we speak.  How can I tell if there is a
> >> certain mode that is permitting this?
> >>     
> >
> > If the boot up says you're running with PMtimer then it uses the fallback
> > (usually happens on pre Fam10h AMD boxes). A typical Intel box
> > would use the faster ring 3 only TSC path and then explode with your
> > change I bet. 
> >   
> 
> Thinking about this some more, perhaps the issue is I am not hitting the
> contended path in vsyscall?

Yes it will be only contended when gettimeofday() races with the timer 
interrupt.  You could try to run gettimeofday() in a loop and see how
long it holds up.

But anyways from the theory you should crash when it happens. 
Writes to kernel data are not allowed in vsyscalls and your read_lock clearly 
does a write.

-Andi

-- 
ak@linux.intel.com

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757096AbYDJQL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbYDJQL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 12:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbYDJQLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 12:11:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52985 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbYDJQLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 12:11:48 -0400
Message-ID: <47FE3B24.4020301@zytor.com>
Date: Thu, 10 Apr 2008 09:07:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       pinskia@gcc.gnu.org
Subject: Re: [PATCH] pop previous section in alternative.c
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com> <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com> <47FD5D42.5000603@zytor.com> <87wsn6m6zt.fsf@basil.nowhere.org> <20080410094637.GW17915@shadowen.org> <Pine.LNX.4.58.0804101007510.5673@gandalf.stny.rr.com> <20080410144114.GH10019@one.firstfloor.org> <alpine.LFD.1.00.0804100741430.3143@woody.linux-foundation.org> <20080410150544.GI10019@one.firstfloor.org> <alpine.LFD.1.00.0804100811400.3143@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0804100811400.3143@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> That would mark gcc itself as buggy, because gcc will move some things 
> into the #APP/#NO_APP thing, and sometimes doesn't end the #APP at all!
> 

That is quite buggy indeed, since the whole #APP and #NO_APP string set 
are arbitrary strings that are part of the gcc configuration, marked as 
"what to insert before user assembly" and "what to insert after user 
assembly."  They are not guaranteed to be simple comments, in fact.

In fact, gas *is* sensitive to #APP ... #NO_APP, so they are not simple 
comments.

	-hpa

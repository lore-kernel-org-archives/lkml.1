Return-Path: <linux-kernel-owner+w=401wt.eu-S1760517AbZBXRbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760517AbZBXRbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760298AbZBXRbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:31:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760291AbZBXRbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:31:03 -0500
Date: Tue, 24 Feb 2009 09:29:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Salman Qazi <sqazi@google.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: Another Performance Regression in write() syscall
In-Reply-To: <1235494732.26788.256.camel@nimitz>
Message-ID: <alpine.LFD.2.00.0902240924490.3111@localhost.localdomain>
References: <20090224060558.GA14812@google.com>  <1235456745.26788.237.camel@nimitz>  <200902241947.53180.nickpiggin@yahoo.com.au> <1235494732.26788.256.camel@nimitz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Feb 2009, Dave Hansen wrote:
> 
> Yeah, that's a good point.  Are we sure that's what is happening here,
> though?  That's one thing a profile would hopefully help with.

One thing to note is that _if_ it's purely an issue of nontemporal stores 
vs normal stores, then profiling is very likely going to be almost 
entirely useless. You'll get "results", but the results have nothing 
what-so-ever to do with reality or anything interesting.

The nontemporal stores may stand out in the profiles, but the actual 
performance impact will be all about whether totally unrelated code got 
cache misses or not. Quite often those cache misses will also be in user 
mode, and very possibly in other processes.

So profiles can certainly be interesting, but if Salman says that his 
patch makes a difference for his benchmark, then profiling is almost 
certainly not interesting FOR THAT PATCH. It's interesting mainly as a way 
to look at whether there are then also _other_ issues that are worth 
addressing (ie the whole atime thing is in a whole different dimension 
and an independent issue).

			Linus

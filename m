Return-Path: <linux-kernel-owner+w=401wt.eu-S1764864AbYDQKTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764864AbYDQKTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757240AbYDQKTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 06:19:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756805AbYDQKTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 06:19:21 -0400
Date: Thu, 17 Apr 2008 03:18:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080417031829.15ec73df.akpm@linux-foundation.org>
In-Reply-To: <87zlrshjtz.fsf@basil.nowhere.org>
References: <20080416202338.GA6007@elte.hu>
	<20080417002552.5742ad65.akpm@linux-foundation.org>
	<20080417083000.GA4935@elte.hu>
	<20080417014054.ea788f1f.akpm@linux-foundation.org>
	<20080417090626.GA14383@elte.hu>
	<20080417021813.04df7912.akpm@linux-foundation.org>
	<20080417093025.GA17389@elte.hu>
	<20080417023603.672d1032.akpm@linux-foundation.org>
	<87zlrshjtz.fsf@basil.nowhere.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 12:11:36 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> >
> > Does it really really really need to consume one of our few remaining page
> > flags?  We'll be in a mess when we run out.
> 
> No we're not. Just the (imho always misguided) "encode zone/node number 
> into flags" optimization has to be removed again or made 64bit only.
> Then there will be plenty of flags again.

hm.  Or we add a new nid&zone field to the pageframe for 32bit NUMA.  Just
don't tell Paul Mundt ;)

Need to work out what's going on with ia64's use of the upper 32 bits too. 
I have a feeling it's using less than it used too but at 3AM I can't be
assed working it out.

> Really I see no real reason this can't be done with a small hash table
> again like x86-64 originally did.

How did that work?  A pfn->zone-id hash table would be huge?

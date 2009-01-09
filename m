Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbZAICZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbZAICZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 21:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZAICZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 21:25:01 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:21720 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbZAICY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 21:24:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=B4MVsgUB6LqsxOU5hTF3ELPBAhe0/lPOvDCh3KS3XfreBczMIzooF5BgB092rtM2pV
         6UPxhHMsBjCcfSHqtzO2gXdlhYY5VD0M2/hz3t6AHPPifN64x6yQ/6v+PYbDYb9nV+9o
         iIWKdLRVWj0a+N5GOBsj4w2G2s3UhFVznn+J0=
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
In-Reply-To: <4966ABF9.9080409@zytor.com>
References: <1231365115.11687.361.camel@twins>
	 <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>
	 <1231366716.11687.377.camel@twins>
	 <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>
	 <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu>
	 <1231426014.11687.456.camel@twins>
	 <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>
	 <1231434515.14304.27.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
	 <20090108183306.GA22916@elte.hu> <1231444786.5715.8.camel@brick>
	 <4966ABF9.9080409@zytor.com>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 18:24:56 -0800
Message-Id: <1231467896.5715.40.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 17:44 -0800, H. Peter Anvin wrote:
> Harvey Harrison wrote:
> >>
> >> We might still try the second or third options, as i think we shouldnt go 
> >> back into the business of managing the inline attributes of ~100,000 
> >> kernel functions.
> > 
> > Or just make it clear that inline shouldn't (unless for a very good reason)
> > _ever_ be used in a .c file.
> > 
> 
> The question is if that would produce acceptable quality code.  In
> theory it should, but I'm more than wondering if it really will.
> 
> It would be ideal, of course, as it would mean less typing.  I guess we
> could try it out by disabling any "inline" in the current code that
> isn't "__always_inline"...
> 

A lot of code was written assuming inline means __always_inline, I'd suggest
keeping that assumption and working on removing inlines that aren't
strictly necessary as there's no way to know what inlines meant 'try to inline'
and what ones really should have been __always_inline.

Not that I feel _that_ strongly about it.

Cheers,

Harvey


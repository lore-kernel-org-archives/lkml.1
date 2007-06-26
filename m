Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbXFZCMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbXFZCMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 22:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbXFZCMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 22:12:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:30386 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbXFZCML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 22:12:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QisTka527syXmdkHfcyx6Cklviow7uMZE37l4cSZSvV/c9jtHQDhazu0jisWk1i917pghH6DicZ1hxFA5BCrNFh+s8ntZ+uTI0H9obk53p3L4JxXFgYcQMCgSlmTmgS8W1d3yOxhGXuDFAz8Mtm626xkaAVbfR+JPr36yllm4Rk=
Message-ID: <e9c3a7c20706251912i77ac75a0o60981590a08c34e6@mail.gmail.com>
Date: Mon, 25 Jun 2007 19:12:10 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Christoph Hellwig" <hch@infradead.org>,
       "john stultz" <johnstul@us.ibm.com>, "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Dipankar Sarma" <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
In-Reply-To: <1182823276.5493.240.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622040014.234651401@goodmis.org>
	 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
	 <20070622204058.GA11777@elte.hu>
	 <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
	 <20070622215953.GA22917@elte.hu>
	 <e9c3a7c20706251846v17347ab2n4a1d314734528c95@mail.gmail.com>
	 <1182823276.5493.240.camel@localhost.localdomain>
X-Google-Sender-Auth: 2c1cdd335a8f37ad
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/07, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2007-06-25 at 18:46 -0700, Dan Williams wrote:
> >
> > Context switches on this platform flush the L1 cache so bouncing
> > between a workqueue and the MD thread is painful.
>
> Why is context switches between two kernel threads flushing the L1
> cache?  Is this a flaw in the ARM arch?  I would think the only thing
> that needs to be done between a context switch of two kernel threads (or
> even a user thread to a kernel thread) is update the general regs and
> stack. The memory access (page_tables or whatever ARM uses) should stay
> the same.
>
Yes you are right, ARM does not flush L1 when prev==next in switch_mm.

> Perhaps something else is at fault here.
>
I'll try and dig a bit deeper...

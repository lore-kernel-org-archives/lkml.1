Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbZDAIB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbZDAIB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbZDAIBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:01:47 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:58119 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbZDAIBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:01:46 -0400
Date: Wed, 1 Apr 2009 10:01:17 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
Message-ID: <20090401100117.04775dd2@skybase>
In-Reply-To: <alpine.DEB.1.10.0903311708540.30693@qirst.com>
References: <1236671631-9305-1-git-send-email-tj@kernel.org>
	<20090316190132.7965a49a@skybase>
	<49C300D8.5080204@kernel.org>
	<49C8FAC4.6060508@kernel.org>
	<20090325122738.42d105b7@skybase>
	<49CA1AC3.9080908@kernel.org>
	<20090325122241.GE11571@elte.hu>
	<49CA2345.70204@kernel.org>
	<20090325141330.2717dc97@skybase>
	<49CA2FBF.9000207@kernel.org>
	<20090325142525.2d31c522@skybase>
	<49CA32F6.2030408@kernel.org>
	<20090331185431.72ff1707@skybase>
	<alpine.DEB.1.10.0903311318300.1912@qirst.com>
	<20090331221847.50ea3356@skybase>
	<alpine.DEB.1.10.0903311708540.30693@qirst.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 17:10:40 -0400 (EDT)
Christoph Lameter <cl@linux.com> wrote:

> On Tue, 31 Mar 2009, Martin Schwidefsky wrote:
> 
> > > Please include the patch inline next time.
> >
> > What do you mean by "inline"? That the patch should not be the last
> > thing in the mail?
> 
> The patch needs to show up when I press reply and not vanish. I guess this
> was an attachment.

Hmm, interesting. The patch was part of the message body but came after
the signature. I'll make the signature the last thing in my mails in the
future.

> > I don't see how changes to the initial per cpu segment should help with
> > access to per cpu symbols.
> 
> Can you convince the linker to place the per cpu segment > 4G away from
> the code? Its a virtual address right?

Yes it is a virtual address but the linker has nothing to do with it.
It is the compiler that makes the assumption that an static variable
can be accessed within < 4G. The module loader then rips the code and
the .data.percpu section apart and places them at memory locations
which are farther away than 4GB.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


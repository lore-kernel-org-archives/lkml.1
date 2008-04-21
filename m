Return-Path: <linux-kernel-owner+w=401wt.eu-S1760280AbYDUTv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280AbYDUTv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbYDUTvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:51:51 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:42548 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbYDUTvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:51:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=g9bHY9ITD/lreeA+CLDdhW3Q0FvItYeHbgYkUBwWH97XSW/3Zvf73ZCVWe31Zy8TXxE616jkOOJDq7iyTcY9yY7agJXAR3X2GXTaQCqwWkslxQlBUghZf1YLt325tBLkxNGg5Z/EgS/GBncZlYK0A+nf4bkGLG/t2HP1rBXoaAs=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: x86: 4kstacks default
Date: Mon, 21 Apr 2008 21:51:02 +0200
User-Agent: KMail/1.8.2
Cc: Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <200804210945.24479.vda.linux@googlemail.com> <480C96BC.4020400@sandeen.net>
In-Reply-To: <480C96BC.4020400@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804212151.02241.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 April 2008 15:29, Eric Sandeen wrote:
> > Some number has to be picked. Why fitting in 4k is "bad" and fitting
> > in 8k is "not bad"?
> 
> 
> Because well-written code in several subsystems, used in combination in
> common configurations, does not always fit, that is why.
> 
> Show me the "bug" in an nfs+xfs+md+scsi writeback stack oops

Why nfs+xfs+md+ide works? Does scsi intrinsically require more stack
than ide?

Why xfs code is said to be 5 timed bigged than e.g. reiserfs?
Does it have to be that big? Does it really have to eat lots of stack?

> and I'm 
> sure it'll get "fixed."  But if it's simply complex code that happens to
> need >4k, I will continue to argue that the limited stack size selection
> is the problem, not the code running in it.

8k stack is limited too. Other Operating System, no doubt in the name
of better stability, has even larger stack (16k or more).

For what its worth, I do realize that there is a point of diminishing
returns and increased pain when one tries to reduce stack usage.
I feel that 4k for 32-bit x86 is not too painful. IMO, of course.

> If someone has a workload and configuration which happens to fit in 4k
> then turn it on, test the heck out of it, and have fun.  I've not seen
> what I consider to be a convincing argument for making it the default
> for everyone.

Conversely:

"If someone is strongly concerned about possibility of stack overflow,
then turn on 8k option, and enjoy the benefits of wide testing which
is provided by millions of people who run 4k stacks. If _that_ works
ok in practice, 8k _ought_ to be 100.00% safe versus stack overflow".

These threads about 4k stack seem to degenerate in ping-ponging
of these arguments again and again.
--
vda

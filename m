Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbZKPPM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbZKPPM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 10:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbZKPPM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 10:12:28 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52138 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbZKPPM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 10:12:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LpsZ1yLW1JYUi3WxKde8AyuB3d1XS+q+z2WBAgj8ynFP8sPZr3mM4i6ggV4zZeJ5kA
         ayhgFp7K9jUng5GS3h3egaXz3NWlnd2wl1hoXd+EqAWBLR1iNb3oUZANh02/66arQ7po
         pZ2rxMMIy7XeBRSI43GxZ1WXZM8aWv4FDpdTg=
Date: Mon, 16 Nov 2009 16:12:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86: Add missing might_fault() from
	copy_{to,from}_user()
Message-ID: <20091116151231.GA5293@nowhere>
References: <1258382538-30979-1-git-send-email-fweisbec@gmail.com> <20091116150937.GA22187@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091116150937.GA22187@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 04:09:37PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > In x86-64, copy_to/from_user() rely on assembly routines that never
> > call might_fault(), making us missing various lockdep checks.
> > 
> > This doesn't apply to __copy_from,to_user() that explicitly handle
> > these calls, neither is it a problem in x86-32 where
> > copy_to,from_user() rely on the "__" prefixed versions that also call
> > might_fault().
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  arch/x86/include/asm/uaccess_64.h |   10 +++++++++-
> >  arch/x86/lib/copy_user_64.S       |    4 ++--
> >  2 files changed, 11 insertions(+), 3 deletions(-)
> 
> Looks good - other than that you missed the renaming of the symbol 
> export line in arch/x86/kernel/x8664_ksyms_64.c, which i fixed.



Oops, sorry!

 
> Thanks,
> 
> 	Ingo


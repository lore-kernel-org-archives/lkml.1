Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbZJUVpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbZJUVpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 17:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbZJUVph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 17:45:37 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:52774 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbZJUVph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 17:45:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pf7iJJ/tAWMTKqLjmxSlfDhGxuy3C0gCeMoUVXlb04FEWV4v9BGaMGtQ4KPg1RR1eR
         psR7CmEfqk86OODC1Aphj/04U8LERj4oT/cHLQZsyBsLJNsrhjHtS5UgY5euntwa/IB+
         seyOyGNTL9LqwRx02OG+ASUDAhf+Iqo4FJG7A=
Date: Wed, 21 Oct 2009 23:45:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jonathan Corbet <corbet@lwn.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>
Subject: Re: [PATCH] macintosh: Explicitly set llseek to no_llseek in
	ans-lcd
Message-ID: <20091021214537.GD4880@nowhere>
References: <20091010153314.827301943@linutronix.de> <20091010153349.966159859@linutronix.de> <alpine.LFD.2.00.0910212305090.3526@localhost.localdomain> <20091021212137.GB4880@nowhere> <alpine.LFD.2.00.0910212327160.3526@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0910212327160.3526@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 11:33:17PM +0200, John Kacur wrote:
> > Should we better pushdown default_llseek to every to every
> > file operations that don't implement llseek?
> > I don't know how many of them don't implement llseek() though.
> > 
> > That said we can't continue anymore with this default attribution
> > of default_llseek() on new fops.
> > 
> 
> If you don't explicitly set it to no_llseek, you automatically get the
> default_llseek, which uses the BKL. So if your driver doesn't need it, it 
> is best to explicitly set it to no_llseek.


Sure, that's the right thing to do.

 
> There is also a generic_file_llseek_unlocked, somewhat analogous to the 
> unlocked_ioctls that you can use if you don't need to provide a full 
> llseek yourself.


No problem with that. Setting no_llseek or generic_file_llseek_unlocked,
depending on the context is the right thing to do.

What I'm wondering about concerns the future code that will have
no llsek() implemented in their fops.

We can't continue to use default_llseek() for future code unless we
want to continue these post reviews and fixes forever.


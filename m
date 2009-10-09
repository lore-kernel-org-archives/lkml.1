Return-Path: <linux-kernel-owner+w=401wt.eu-S1761384AbZJITaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384AbZJITaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 15:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761375AbZJITaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 15:30:55 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:9181 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761374AbZJITay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 15:30:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NqOBRxxoMqhDRUxQl5xh3RysDjUjRsmELiyurL4woGL3o/2weDHBUNbe4vgnG4ATcS
         rdxIr+apS4mD17EJcxB3kpIv9BK4vlCm9n47od2KkJrsuRpcZ2B0slo0HQIWMYhRYFgL
         uNgYhjwDLN+JN1XCLmChRQdp0g1A2EszQ1/eE=
Date: Fri, 9 Oct 2009 21:29:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Jonathan Corbet <corbet@lwn.net>,
       Alessio Igor Bogani <abogani@texware.it>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] nvram: Drop the bkl from nvram_llseek()
Message-ID: <20091009192945.GA5859@nowhere>
References: <1255116030-6929-1-git-send-email-fweisbec@gmail.com> <alpine.LFD.2.00.0910092124260.9428@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0910092124260.9428@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 09:27:17PM +0200, Thomas Gleixner wrote:
> B1;2005;0cOn Fri, 9 Oct 2009, Frederic Weisbecker wrote:
> 
> > There is nothing to protect inside nvram_llseek(), the file
> > offset doesn't need to be protected and nvram_len is only
> > initialized from an __init path.
> > 
> > It's safe to remove the big kernel lock there.
> > 
> > (Is this file still used? I can't even build it,
> > looks like it is built under CONFIG_GENERIC_NVRAM but this
> > option is referenced nowhere except in powerpc defconfigs)
> 
> Yes it is used. Look at arch/powerpc/Kconfig
> 
> config GENERIC_NVRAM
>         bool
> 	default y if PPC32


Oh right, I missed it.

 
> But I have to admit that the GENERIC part is confusing :)


Yep :)


> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: John Kacur <jkacur@redhat.com>
> > Cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
> > Cc: Jonathan Corbet <corbet@lwn.net>
> > Cc: Alessio Igor Bogani <abogani@texware.it>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Greg KH <gregkh@suse.de>
> 
> Added to the pile of pending BKL bashing. Thanks,
> 
>       tglx      


Ok. Be care I couldn't even build test this one.

Thanks.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab0BBQck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 11:32:40 -0500
Received: from verein.lst.de ([213.95.11.210]:56372 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab0BBQcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 11:32:39 -0500
Date: Tue, 2 Feb 2010 17:31:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       tony.luck@intel.com, ralf@linux-mips.org, kyle@mcmartin.ca,
       benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, davem@davemloft.net, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 4/6] improve sys_personality for compat architectures
Message-ID: <20100202163145.GA30659@lst.de>
References: <20100201185607.GD11045@lst.de> <201002021536.51928.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002021536.51928.arnd@arndb.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 03:36:51PM +0100, Arnd Bergmann wrote:
> > -       return (long)old;
> > +       return (long)(old == PER_LINUX32 ? PER_LINUX : old);
> >  }
> 
> What does this do for a native 64 bit process setting PER_LINUX32?
> It looks to me like it could never set it back to the original
> value, or am I missing something here?
> 
> It's what the arch specific code does already, but it seems a bit
> strange anyway.

Indeed, this prevents a process from going back to 64bit.  And while
the setarch tool in util-linux also allows going back to 64-bit the
typical use case seems to be going into 32-bit mode.

But if the consensus is that we should fix this properly I can
replace the patch with one introducing a compat_sys_personality
which only gets used for compat tasks.


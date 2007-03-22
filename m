Return-Path: <linux-kernel-owner+w=401wt.eu-S932901AbXC0QOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbXC0QOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932819AbXC0QOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:14:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2674 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932901AbXC0QOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:14:53 -0400
Date: Thu, 22 Mar 2007 23:19:17 +0000
From: Pavel Machek <pavel@ucw.cz>
To: David Safford <safford@watson.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [Patch 3/7] integrity: EVM as an integrity service provider
Message-ID: <20070322231917.GC4064@ucw.cz>
References: <1174666176.11149.3.camel@localhost.localdomain> <20070325001605.31ed39e7.akpm@linux-foundation.org> <20070325121321.GA8550@ucw.cz> <1174931715.3493.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174931715.3493.44.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > +	  The Extended Verification Module is an integrity provider.
> > > > +	  An extensible set of extended attributes, as defined in
> > > > +	  /etc/evm.conf, are HMAC protected against modification
> > > > +	  using the TPM's KERNEL ROOT KEY, if configured, or with a
> > > > +	  pass-phrase.  Possible extended attributes include authenticity,
> > > > +	  integrity, and revision level.
> > 
> > What is identity provider good for? Can you explain it a bit more, or
> > perhaps point to Doc*/ somewhere?
> 
> There are some papers and related userspace code at
>    http://www.research.ibm.com/gsal/tcpa
> which describe the architecture in more detail, but basically this 
> integrity provider is designed to complement mandatory access control
> systems like selinux and slim. Such systems can protect a running system 
> against on-line attacks, but do not protect against off-line attacks  
> (booting Knoppix and changing executables or their selinux labels), or 
> against attacks which find weaknesses in the kernel or the LSM module 
> itself.

Thanks. Can this go to Doc*/ somewhere?

...but... If I can attack your system using knoppix, I can get at your
data, already, right? So you'll need to encrypt your data, anyway? 

> Using a TPM or passphrase, EVM can verify the integrity of all files 
> (including the kernel and initrd) and their labels before they are 

How does passphrase work here?

...so you have your data encrypted, and you have bootloader that
verifies kernel/initrd (you need that, anyway). Because you data are
encrypted, knoppix attack will not work... assuming crypto does some
integrity checks, but IIRC crypto needs to do that.

							Pavel,
who is afraid, that this code will come back and bite him. He has
nightmares of opening PS4 box as a christmas gift, then not being able
to hack his new hardware.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

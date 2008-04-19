Return-Path: <linux-kernel-owner+w=401wt.eu-S1761788AbYDSQm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761788AbYDSQm1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 12:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbYDSQmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 12:42:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52895 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbYDSQmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 12:42:16 -0400
Date: Sat, 19 Apr 2008 18:42:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.25
Message-ID: <20080419164202.GA28328@elte.hu>
References: <1208540517.3063.18.camel@localhost.localdomain> <20080419151934.GA17089@elte.hu> <1208620484.3280.23.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208620484.3280.23.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> >  drivers/built-in.o: In function `sas_request_addr':
> >  : undefined reference to `release_firmware'
> > 
> > config can be found at:
> > 
> >    http://redhat.com/~mingo/misc/config-Sat_Apr_19_16_58_35_CEST_2008.bad
> > 
> > ... brought to you by x86.git's randconfig build and boot service ;-)
> 
> This one's fun.  The root cause is 
> 
> CONFIG_SCSI_SAS_LIBSAS=y
> CONFIG_FW_LOADER=m
> 
> The problem is that libsas doesn't depend on the FW loader and doesn't 
> want to.  It just wants to use it if it's available.  The definitions 
> in include/linux/firmware.h have stubs to facilitate this.
> 
> However, CONFIG_FW_LOADER=m defeats the stubs.
> 
> This is a bit nasty to fix; however, I think this patch does.  I've 
> also put a large comment in to explain what's going on.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

thanks James - your fix works fine here.

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo

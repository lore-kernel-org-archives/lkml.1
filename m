Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbZJ2OHC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbZJ2OHC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 10:07:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbZJ2OHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 10:07:00 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39751 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359AbZJ2OG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 10:06:58 -0400
Date: Thu, 29 Oct 2009 09:05:47 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Ulrich Drepper <drepper@redhat.com>, linux-api@vger.kernel.org,
       James Morris <jmorris@namei.org>
Subject: Re: [PATCH resend] define convenient securebits masks for prctl
	users
Message-ID: <20091029140547.GC15713@us.ibm.com>
References: <20091028140236.GA8157@us.ibm.com> <20091029133306.0cb87521.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091029133306.0cb87521.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Rothwell (sfr@canb.auug.org.au):
> Hi Serge,
> 
> On Wed, 28 Oct 2009 09:02:36 -0500 "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> >
> > [ Are there any objections to exporting securebits.h?  If not,
> > can this patch be pushed to linux-next? ]
> 
> I am not sure which tree this belongs in?  Maybe security-testing (James
> cc'd)?

I don't know why that didn't occur to me!  Thanks, I'll pursue
that :)

> > diff --git a/include/linux/securebits.h b/include/linux/securebits.h
> > index d2c5ed8..9ad109e 100644
> > --- a/include/linux/securebits.h
> > +++ b/include/linux/securebits.h
> > @@ -1,6 +1,13 @@
> >  #ifndef _LINUX_SECUREBITS_H
> >  #define _LINUX_SECUREBITS_H 1
> >  
> > +/* Each securesetting is implemented using two bits. One bit specifies
> > +   whether the setting is on or off. The other bit specify whether the
> > +   setting is locked or not. A setting which is locked cannot be
> > +   changed from user-level. */
> > +#define issecure_mask(X)	(1 << (X))
> > +#define issecure(X)		(issecure_mask(X) & current_cred_xxx(securebits))
> 
> You want this second define protected by ifdef __KERNEL__ ...

True, userspace doesn't need to see those.  Will sanitize and resend.

thanks,
-serge
